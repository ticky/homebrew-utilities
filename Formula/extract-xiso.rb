class ExtractXiso < Formula
  desc "Xbox ISO Creation/Extraction utility"
  homepage "http://sourceforge.net/projects/extract-xiso/"
  url "https://github.com/XboxDev/extract-xiso.git", revision: "4488c39d7aa0bd0c371929a3fdeb456123aa46b3"
  version "2.7.1-ticky.1"
  license "BSD-4-Clause"
  head "https://github.com/XboxDev/extract-xiso.git"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "extract-xiso v#{version.to_s.split("-").first}",
                 shell_output("#{bin}/extract-xiso -v")
  end
end
