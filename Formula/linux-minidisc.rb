class LinuxMinidisc < Formula
  desc "Free software for accessing MiniDisc devices"
  homepage "https://github.com/glaubitz/linux-minidisc"
  url "https://github.com/glaubitz/linux-minidisc.git", :tag => "0.9.16"
  version "0.9.16"

  head "https://github.com/glaubitz/linux-minidisc.git"

  # Dependencies copied from "build/install_dependencies.sh" in the linux-minidisc repo
  depends_on "qt5"
  depends_on "mad"
  depends_on "libid3tag"
  depends_on "libtag"
  depends_on "glib"
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "libgcrypt"

  def install
    system "qmake"
    system "make"
    # TODO: Install produced binaries <https://git.io/fh54E>
  end
end
