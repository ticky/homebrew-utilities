class Retro68 < Formula
  desc "GCC-based cross-compiler for classic 68K and PPC Macintoshes"
  homepage "https://github.com/autc04/Retro68/"
  url "https://github.com/autc04/Retro68.git", commit: "fbdf2c4bcbeed434ab803a5899792612204074bf"
  version "2020-07-22T180229Z"
  head "https://github.com/autc04/Retro68.git"
  # Formula adapted from https://github.com/Homebrew/homebrew-core/pull/43442

  # NOTE: brew's robot said non-system bison might not be necessary, but I built with it anyway, YMMV
  depends_on "bison"
  depends_on "boost"
  depends_on "cmake"
  depends_on "gmp"
  depends_on "hfsutils"
  depends_on "libmpc"
  depends_on :macos
  depends_on "mpfr"

  conflicts_with "binutils",
                 because: "both install a `share/info/bfd.info` file"

  resource "mpw" do
    url "https://staticky.com/mirrors/ftp.apple.com/developer/Tool_Chest/Core_Mac_OS_Tools/MPW_etc./MPW-GM_Images/MPW-GM.img.bin"
    sha256 "99bbfa95bb9800c8ffc572fce6d72e561f012331c5c623fa45f732502b6fa872"
  end

  resource "ndif_decomp" do
    # platform-agnostic Apple NDIF disk image decompression utility provided by Ninji
    url "https://gist.github.com/75283496204ed4bbcb12fe2a0018d227.git", revision: "865c9e040fbe89f509429659d41d0507c4d4c84b"
  end

  patch :DATA

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("ndif_decomp")
    tmpdir.install resource("mpw")

    chdir tmpdir do
      # First we need to build the NDIF disk image decompressor
      system ENV.cc, "ndif_decomp.c", "-o", "ndif_decomp"

      # Then MacBinary decode the MPW-GM disk image
      system "macbinary", "decode", "MPW-GM.img.bin"

      # Decompress it
      system "./ndif_decomp"

      # "mount" it using hfsutils
      system "hmount", "output.img"
    end

    # Change into the Interfaces&Libraries folder
    system "hcd", ":MPW-GM:Interfaces&Libraries"

    dst = "InterfacesAndLibraries/"

    # Copy the files out of it
    Open3.popen2("hls", "-aFR", ":*") do |_stdin, stdout|
      path = nil
      stdout.each_line do |line|
        line.chomp!
        # puts "LINE: #{line.inspect}"

        # Ignore bare directory names, and separator lines
        next if (line.end_with?(":") && !line.start_with?(":")) || line.empty?

        if line.start_with? ":"
          path = line
          # puts "IN DIRECTORY: #{line}"
          mkdir File.join(dst, path.split(":").join("/"))
        else
          inpath = path + line
          outpath = File.join(dst, path.split(":").join("/"),
line + ".bin").force_encoding("MacRoman").encode("UTF-8")
          # puts "COPY FILE: #{inpath.inspect} to #{outpath.inspect}"
          system "hcopy", "-m", inpath, outpath
          system "macbinary", "decode", outpath
          rm outpath
        end
      end
    end

    system "humount"

    mkdir "build" do
      system "../build-toolchain.bash",
             "--prefix=#{prefix}",
             "--universal",
             "--with-system-hfsutils"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write "add_application(Test test.c CONSOLE)"
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(int argc, char** argv)
      {
        printf("Hello");
        return 0;
      }
    EOS
    cmake_files = [
      "#{prefix}/m68k-apple-macos/cmake/retro68.toolchain.cmake",
      "#{prefix}/powerpc-apple-macos/cmake/retrocarbon.toolchain.cmake",
      "#{prefix}/powerpc-apple-macos/cmake/retroppc.toolchain.cmake",
    ]
    cmake_files.each do |cmake_file|
      mkdir "build" do
        ENV["CFLAGS"] = nil
        ENV["CPATH"] = nil
        ENV["CPPFLAGS"] = nil
        ENV["CXXFLAGS"] = nil
        ENV["LDFLAGS"] = nil
        system "cmake", "..", "-DCMAKE_TOOLCHAIN_FILE=#{cmake_file}"
        system "make"
      end
      rm_rf "build"
    end
  end
end
__END__
diff --git a/build-toolchain.bash b/build-toolchain.bash
index 6e37c72ef4..9de6be9557 100755
--- a/build-toolchain.bash
+++ b/build-toolchain.bash
@@ -37,6 +37,7 @@ fi
 ##################### Command-line Options
 
 SKIP_THIRDPARTY=false
+WITH_SYSTEM_HFSUTILS=false
 BUILD_68K=true
 BUILD_PPC=true
 BUILD_CARBON=true
@@ -51,6 +52,7 @@ function usage()
  echo "Options: "
  echo "    --prefix                  the path to install the toolchain to"
  echo "    --skip-thirdparty         do not rebuild gcc & third party libraries"
+ echo "    --with-system-hfsutils    use system hfsutils (--skip-thirdparty will also skip building hfsutils)"
  echo "    --no-68k                  disable support for 68K Macs"
  echo "    --no-ppc                  disable classic PowerPC CFM support"
  echo "    --no-carbon               disable Carbon CFM support"
@@ -71,6 +73,9 @@ for ARG in $*; do
    --skip-thirdparty)
      SKIP_THIRDPARTY=true
      ;;
+   --with-system-hfsutils)
+     WITH_SYSTEM_HFSUTILS=true
+     ;;
    --no-68k)
      BUILD_68K=false
      ;;
@@ -155,10 +160,10 @@ if [ $SKIP_THIRDPARTY != false ]; then
    if [ ! -d binutils-build-ppc ]; then MISSING=true; fi
    if [ ! -d gcc-build-ppc ]; then MISSING=true; fi
  fi
- if [ ! -d hfsutils ]; then MISSING=true; fi
+ if [ $WITH_SYSTEM_HFSUTILS = false -a ! -d hfsutils ]; then MISSING=true; fi
 
  if [ $MISSING != false ]; then
-   echo "Not all third-party components have been built yet, ignoring --skip-thirdparty."
+   echo "Not all third-party components have been built yet; ignoring --skip-thirdparty and --with-system-hfsutils."
    SKIP_THIRDPARTY=false
  fi
 fi
@@ -306,19 +311,20 @@ if [ $SKIP_THIRDPARTY != true ]; then
  unset CPPFLAGS
  unset LDFLAGS
 
+ if [ $WITH_SYSTEM_HFSUTILS = false ]; then
+   # Build hfsutils
+   mkdir -p $PREFIX/lib
+   mkdir -p $PREFIX/share/man/man1
+   mkdir -p hfsutils
+   cd hfsutils
+   $SRC/hfsutils/configure --prefix=$PREFIX --mandir=$PREFIX/share/man --enable-devlibs
+   make
+   make install
+   cd ..
 
- # Build hfsutil
- mkdir -p $PREFIX/lib
- mkdir -p $PREFIX/share/man/man1
- mkdir -p hfsutils
- cd hfsutils
- $SRC/hfsutils/configure --prefix=$PREFIX --mandir=$PREFIX/share/man --enable-devlibs
- make
- make install
- cd ..
-
- if [ $CLEAN_AFTER_BUILD != false ]; then
-   rm -rf hfsutils
+   if [ $CLEAN_AFTER_BUILD != false ]; then
+     rm -rf hfsutils
+   fi
  fi
 else # SKIP_THIRDPARTY
     removeInterfacesAndLibraries
