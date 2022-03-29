class SpaceCadetPinball < Formula
  desc "Decompilation of 3D Pinball for Windows – Space Cadet"
  homepage "https://github.com/k4zmu2a/SpaceCadetPinball"
  url "https://github.com/k4zmu2a/SpaceCadetPinball.git", tag: "Release_2.0.1"
  head "https://github.com/k4zmu2a/SpaceCadetPinball.git", branch: "master"

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
