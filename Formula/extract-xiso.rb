class ExtractXiso < Formula
  desc "Xbox ISO Creation/Extraction utility"
  homepage "https://sourceforge.net/projects/extract-xiso/"
  url "https://github.com/XboxDev/extract-xiso.git", revision: "4488c39d7aa0bd0c371929a3fdeb456123aa46b3"
  version "2.7.1-ticky.1"
  license "BSD-4-Clause"
  head "https://github.com/XboxDev/extract-xiso.git", branch: "master"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/extract-xiso-2.7.1-ticky.1"
    sha256 cellar: :any_skip_relocation, big_sur:      "6f7162af1f4c655a23b45c2fa7a2db6dd123806e164db361b5e4e40f49c9d6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "071b85aec6c29fd59b71c5de12cc9f88448c53231edabb7e3425ffb19a4efed9"
  end

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
