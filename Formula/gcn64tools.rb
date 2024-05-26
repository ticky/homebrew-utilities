class Gcn64tools < Formula
  desc "Raphnet USB adapter management tools"
  homepage "https://www.raphnet.net/programmation/gcn64tools/index_en.php"
  url "https://www.raphnet.net/programmation/gcn64tools/raphnet-tech_adapter_manager-2.1.30.tar.gz"
  sha256 "a9ac1b661447a223f4082393342306845517541cf46f9ab24377d49a153c9158"
  license "GPL-3.0-only"
  head "https://github.com/raphnet/gcn64tools.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href="raphnet-tech_adapter_manager-(\d+(?:\.\d+)+).tar.gz"/i)
  end

  depends_on "gtk+3"
  depends_on "hidapi"
  depends_on "libxml2"
  depends_on "pkg-config"

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
