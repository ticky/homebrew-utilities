class PpcSwiftLlvm < Formula
  desc "Macintosh Programmer's Workshop (mpw) compatibility layer"
  homepage "https://belkadan.com/source/ppc-swift-project"
  url "https://belkadan.com/source/ppc-swift-project", using: :git, revision: "2fabc10dfcba0eb0ac8957b749b68da1593cece6"
  version "2020-07-12"

  head "https://belkadan.com/source/ppc-swift-project", using: :git

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "git", "clone", "-b", "ppc-swift", "https://belkadan.com/source/swift"
    system "git", "clone", "-b", "ppc-swift", "https://belkadan.com/source/llvm-project"
    system "git", "clone", "https://github.com/apple/swift-cmark", "cmark"
    system "make"

    raise "oops"
  end

  test do
    system bin/"ppc-swift-llvm"
  end
end
