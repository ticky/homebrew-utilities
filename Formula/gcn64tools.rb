class Gcn64tools < Formula
  desc "Raphnet USB adapter management tools"
  homepage "http://www.raphnet.net/programmation/gcn64tools/index_en.php"
  url "https://github.com/raphnet/gcn64tools/archive/refs/tags/v2.1.27.tar.gz"
  sha256 "e907b4084dd6bd9e1ebf0d13da11c4ad2151c2ea9d0d9f6df8b5365eef3bb18e"
  license "GPL-3.0"
  head "https://github.com/raphnet/gcn64tools.git"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on "gtk+3"
  depends_on "hidapi"
  depends_on "libxml2"

  def install
    # the makefile for gcn64tools fails if the bin
    # directory doesn't already exist, so we make sure
    bin.mkdir

    cd "src" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    system "#{bin}/gcn64ctl", "-h"
  end
end
