class Cxmon < Formula
  desc "Interactive command-driven file manipulation tool"
  homepage "https://cxmon.cebix.net/#download"
  url "https://github.com/cebix/macemu.git", revision: "89bcd3dc3ed663934865f7e9e1b99c13a1c13db7"
  version "2020-07-05T515644Z"
  revision 1

  head "https://github.com/cebix/macemu.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    cd "cxmon" do
      system "./bootstrap"
      system "./configure"
      system "make"
      bin.install "src/cxmon"
      man1.install "cxmon.1"
    end
  end
end
