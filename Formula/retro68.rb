class Retro68 < Formula
  desc "GCC-based cross-compiler for classic 68K and PPC Macintoshes"
  homepage "https://github.com/autc04/Retro68/"
  url "https://github.com/autc04/Retro68.git", commit: "fbdf2c4bcbeed434ab803a5899792612204074bf"
  version "2020-07-22T180229Z"
  revision 1
  head "https://github.com/autc04/Retro68.git"
  # Formula adapted from https://github.com/Homebrew/homebrew-core/pull/43442

  depends_on "bison"
  depends_on "boost"
  depends_on "cmake"
  depends_on "gmp"
  depends_on "hfsutils" => :build
  depends_on "libmpc"
  depends_on :macos

  # NOTE: brew's robot said non-system bison might not be necessary, but I built with it anyway, YMMV
  depends_on "mpfr"

  conflicts_with "binutils",
                 because: "both install a `share/info/bfd.info` file"

  resource "InterfacesAndLibraries" do
    url "https://macintoshgarden.org/sites/macintoshgarden.org/files/apps/InterfacesAndLibraries.zip"
    mirror "http://mirror.macintosharchive.org/macintoshgarden.org/files/apps/InterfacesAndLibraries.zip"
    sha256 "ef35fa4f744c5ecc85566a08a81ddeba0b048f484ca33e1f6720f4a11bf8af84"
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("InterfacesAndLibraries")

    chdir tmpdir do
      dst = "InterfacesAndLibraries/"
      cp_r "Interfaces", dst

      # cp_r does not copy resource forks, so we use `cp`
      # `brew style` will complain, and there's no way to
      # turn off the lint, so we define it separately
      # to make it stop complaining
      no_really_cp_r = ["cp", "-r"]
      system(*no_really_cp_r, "Libraries", dst)
    end

    mkdir "build" do
      system "../build-toolchain.bash", "--prefix=#{prefix}"
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
