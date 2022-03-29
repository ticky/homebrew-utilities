class SpaceCadetPinball < Formula
  desc "Decompilation of 3D Pinball for Windows – Space Cadet"
  homepage "https://github.com/k4zmu2a/SpaceCadetPinball"
  url "https://github.com/k4zmu2a/SpaceCadetPinball.git", tag: "Release_2.0.1"
  head "https://github.com/k4zmu2a/SpaceCadetPinball.git", branch: "master"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/space-cadet-pinball-2.0.1"
    sha256 cellar: :any,                 big_sur:      "d40aaa3d91d06730fbb72b9f915cf6ce9d185e93d333db398855c72b05827e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e96aea3f9943aa8b08b5519b50002fce5193324476955b146badc353157c171"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    mkdir "build"
    cd "build" do
      system "cmake", ".."
      system "make"
    end

    bin.install "bin/SpaceCadetPinball"
  end

  test do
    assert_match "PINBALL.DAT",
                 shell_output("strings #{bin}/SpaceCadetPinball")
  end
end
