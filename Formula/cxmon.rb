class Cxmon < Formula
  desc "Interactive command-driven file manipulation tool"
  homepage "https://cxmon.cebix.net/#download"
  url "https://github.com/cebix/macemu.git", revision: "89bcd3dc3ed663934865f7e9e1b99c13a1c13db7"
  version "2020-07-05T515644Z"
  revision 1

  head "https://github.com/cebix/macemu.git"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/cxmon-2020-07-05T515644Z_1"
    cellar :any_skip_relocation
    sha256 "1002859f4738ee9b1eb76fac1f845c1cd3a857ae0b63506ed95fa141e4272c0e" => :catalina
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :macos

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
