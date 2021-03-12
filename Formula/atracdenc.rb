class Atracdenc < Formula
  desc "Dirty implementation of ATRAC1, ATRAC3 encoder"
  homepage "https://github.com/dcherednik/atracdenc"
  url "https://github.com/dcherednik/atracdenc.git", tag: "0.0.3"

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
end
