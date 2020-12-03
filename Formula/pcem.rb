class Pcem < Formula
  desc "IBM PC emulator"
  homepage "https://bitbucket.org/pcem_emulator/pcem"
  url "https://bitbucket.org/pcem_emulator/pcem", :using => :hg, :revision => "3a9afaf8f184b106179a1dd7b176298c44d68f85"
  version "2018-08-31T00:46:38-07:00"

  head "https://bitbucket.org/pcem_emulator/pcem"

  depends_on "sdl2"
  depends_on "wxwidgets"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cmake" => :build

  def install
    system "./configure", "--enable-release-build"
    system "make"
  end
end
