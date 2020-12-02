class Cxmon < Formula
  desc "Interactive command-driven file manipulation tool"
  homepage "http://cxmon.cebix.net/#download"
  url "https://github.com/cebix/macemu.git", revision: "89bcd3dc3ed663934865f7e9e1b99c13a1c13db7"
  version "2020-07-05T21:56:44Z"

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
