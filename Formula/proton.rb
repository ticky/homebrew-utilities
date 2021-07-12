class Proton < Formula
  desc "Compatibility tool for Steam Play based on Wine and additional components"
  homepage "https://github.com/ValveSoftware/Proton"
  url "https://github.com/ValveSoftware/Proton.git", tag: "proton-3.7-20180821"
  version "3.7-20180821"

  head "https://github.com/ValveSoftware/Proton.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    system "./build_proton.sh"
    system "ls", "dist"
  end
end
