class Atracdenc < Formula
  desc "Dirty implementation of ATRAC1, ATRAC3 encoder"
  homepage "https://github.com/dcherednik/atracdenc"
  url "https://github.com/dcherednik/atracdenc.git", tag: "0.0.3"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/atracdenc-0.0.3"
    sha256 cellar: :any,                 catalina:     "080906cc37f56e87cc674d298e5ad2bb9288f0700beccf394312d508efa623ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a01a70dbd2c881907c3d2f3b5fb50e00076ec363949f5f891fc4445554ec9c85"
  end

  depends_on "cmake" => :build
  depends_on "libsndfile"

  def install
    cd "src" do
      mkdir "build"
      cd "build" do
        system "cmake", ".."
        system "make"

        bin.install "atracdenc"
      end
    end
  end

  test do
    system bin/"atracdenc", "--help"
  end
end
