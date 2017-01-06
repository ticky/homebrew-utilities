class Tcat < Formula
  desc "A program to add timestamps to text"
  homepage "https://github.com/ticky/tcat"
  head "https://github.com/ticky/tcat.git"

  def install
    system "make"
    bin.install "tcat"
  end
end
