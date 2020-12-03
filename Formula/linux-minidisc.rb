class LinuxMinidisc < Formula
  desc "Free software for accessing MiniDisc devices"
  homepage "https://github.com/ticky/linux-minidisc"
  url "https://github.com/ticky/linux-minidisc.git", tag: "0.9.17-ticky.1"
  version "0.9.17-ticky.1"

  head "https://github.com/ticky/linux-minidisc.git"

  depends_on "pkg-config" => :build

  # Dependencies from "build/install_dependencies.sh" in the linux-minidisc repo
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "mad"
  depends_on "qt"
  depends_on "taglib"

  def install
    system "qmake"
    system "make"
    system "macdeployqt", "qhimdtransfer/QHiMDTransfer.app"
    bin.install "himdcli/himdcli", "netmdcli/netmdcli", "qhimdtransfer/QHiMDTransfer.app"
  end
end
