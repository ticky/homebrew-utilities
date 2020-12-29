class LinuxMinidisc < Formula
  desc "Free software for accessing MiniDisc devices"
  homepage "https://github.com/ticky/linux-minidisc"
  url "https://github.com/ticky/linux-minidisc.git", tag: "0.9.17-ticky.2"
  version "0.9.17-ticky.2"

  head "https://github.com/ticky/linux-minidisc.git"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/linux-minidisc-0.9.17-ticky.1_1"
    sha256 "6daf4373eda137d219419e5f7f2af1644729deb5d923f3bbccf7c9718a159c9b" => :catalina
  end

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
    system "qmake", "INCLUDEPATH+=#{Formula["libgcrypt"].opt_include}",
                    "LIBS+=-L#{Formula["libgcrypt"].opt_lib}",
                    "INCLUDEPATH+=#{Formula["libgpg-error"].opt_include}",
                    "LIBS+=-L#{Formula["libgpg-error"].opt_lib}",
                    "INCLUDEPATH+=#{Formula["libid3tag"].opt_include}",
                    "LIBS+=-L#{Formula["libid3tag"].opt_lib}"
    system "make"

    if OS.mac?
      system "macdeployqt", "qhimdtransfer/QHiMDTransfer.app"
      bin.install "qhimdtransfer/QHiMDTransfer.app"
    end

    bin.install "himdcli/himdcli", "netmdcli/netmdcli"
  end
end
