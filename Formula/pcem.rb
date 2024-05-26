class Pcem < Formula
  desc "IBM PC emulator"
  homepage "https://pcem-emulator.co.uk"
  url "https://github.com/PCemOnMac/PCemV17macOS.git", revision: "180d7cd7f924219534813c5b38987834bb9971df"
  version "v17.0.0-beta+git180d7cd7f924219534813c5b38987834bb9971df"

  head "https://github.com/PCemOnMac/PCemV17macOS.git"

  depends_on "sdl2"
  depends_on "wxwidgets"

  def install
    # Dev's preferred optimization level
    ENV.O3

    system "./configure", "--prefix=#{prefix}",
                          "--enable-networking",
                          "--enable-release-build"
    system "make", "install"
  end
end
