class Tcat < Formula
  desc "Time Cat is a program to add timestamps to text"
  homepage "https://github.com/ticky/tcat"
  url "https://github.com/ticky/tcat.git", revision: "ddf7dc3cb3e902216f65e47d4daf02ff0628e20f"
  version "2014-08-24T511029Z"
  revision 1

  head "https://github.com/ticky/tcat.git"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/tcat-2014-08-24T511029Z_1"
    sha256 cellar: :any_skip_relocation, catalina:     "2b67ba289bd7488c4a373a52562aa6d2c4af3b0879716e23390422527f0c7f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a0150e62b24e1ef942515ee4cc10aff8a3e470baf77ecd188b1ac7f2dd0e0c86"
  end

  def install
    system "make"
    bin.install "tcat"
  end
end
