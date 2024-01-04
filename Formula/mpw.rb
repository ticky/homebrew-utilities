class Mpw < Formula
  desc "Macintosh Programmer's Workshop (mpw) compatibility layer"
  homepage "https://github.com/ksherlock/mpw"
  url "https://github.com/ksherlock/mpw.git", revision: "1a9cb0d7669aaced5f57206de2dd4334d7061bf1"
  version "2020-07-14T03:43:24Z"

  head "https://github.com/ksherlock/mpw.git"

  depends_on "cmake" => :build
  depends_on "ksherlock/ksherlock/lemonxx" => :build
  depends_on "ragel" => :build
  depends_on :macos

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"mpw"
  end
end
