class Retro68 < Formula
  desc "GCC-based cross-compiler for classic 68K and PPC Macintoshes"
  homepage "https://github.com/autc04/Retro68/"
  url "https://github.com/autc04/Retro68.git", revision: "1bf09c8b5f7118e57dd63eed0e8c2c6da4daccd1"
  version "2021-ticky.05.31.0439"
  head "https://github.com/autc04/Retro68.git"
  # Formula adapted from https://github.com/Homebrew/homebrew-core/pull/43442

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/retro68-2021-ticky.05.31.0439"
    sha256 catalina: "9c63e15d779890e7887da56f8f06abfece2dc9c88f7625e0e929d58ed28ee883"
  end

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
  conflicts_with "cdrtools",
                 because: "both install a `lib/libhfs.a` file"

  resource "mpw" do
    url "https://staticky.com/mirrors/ftp.apple.com/developer/Tool_Chest/Core_Mac_OS_Tools/MPW_etc./MPW-GM_Images/MPW-GM.img.bin"
    mirror "https://macintoshgarden.org/sites/macintoshgarden.org/files/apps/mpw-gm.img__0.bin"
    mirror "http://mirror.macintosharchive.org/macintoshgarden.org/files/apps/mpw-gm.img__0.bin"
    mirror "http://old.macintosh.garden/apps/mpw-gm.img__0.bin"
    sha256 "99bbfa95bb9800c8ffc572fce6d72e561f012331c5c623fa45f732502b6fa872"
  end

  resource "ndif_decomp" do
    # platform-agnostic Apple NDIF disk image decompression utility provided by Ninji
    url "https://gist.github.com/75283496204ed4bbcb12fe2a0018d227.git", revision: "865c9e040fbe89f509429659d41d0507c4d4c84b"
  end

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
          outpath = File.join(dst,
                              path.split(":").join("/"),
                              line + ".bin")
                        .force_encoding("MacRoman")
                        .encode("UTF-8")
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
             "--universal"

      (pkgshare/"build-target").install "build-target/AutomatedTests",
                                        "build-target/Console",
                                        "build-target/LaunchAPPL",
                                        "build-target/Samples",
                                        "build-target/TestApps"

      (pkgshare/"build-target-carbon").install "build-target-carbon/AutomatedTests",
                                               "build-target-carbon/Console",
                                               "build-target-carbon/LaunchAPPL",
                                               "build-target-carbon/Samples",
                                               "build-target-carbon/TestApps"

      (pkgshare/"build-target-ppc").install "build-target-ppc/AutomatedTests",
                                            "build-target-ppc/Console",
                                            "build-target-ppc/LaunchAPPL",
                                            "build-target-ppc/Samples",
                                            "build-target-ppc/TestApps"
    end

    # hfsutils utilities and manual pages can't be linked alongside the Homebrew versions
    rm man/"man1/hfsutils.1"

    %w[hattrib hcd hcopy hdel hdir hformat hls hmkdir hmount hpwd hrename hrmdir humount hvol].each do |binname|
      libexec.install bin/binname
      rm man/"man1/#{binname}.1"
    end
  end

  def caveats
    <<~EOS
      Retro68's copies of the `hfsutils` binaries are not linked.
      They can be found in the following directory if needed:
        #{libexec}

      Sample programs and utilities for target platforms can be found in the following directories:
        #{pkgshare/"build-target"}
        #{pkgshare/"build-target-carbon"}
        #{pkgshare/"build-target-ppc"}

      For more information about those programs, please consult the included Readme:
        #{prefix/"README.md"}
    EOS
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
