class Megatools < Formula
  desc "Command-line client for Mega.co.nz (Experimental version)"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/experimental/megatools-1.11.0-git-20220401.tar.gz"
  version "1.11.0-git-20220401"
  sha256 "e63fc192c69cb51436beff95940b69e843a0e82314251d28e48e9388c374b3f1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://megatools.megous.com/builds/experimental/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+-git-[0-9]+)\.t/i)
  end

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/megatools-1.11.0-git-20220401"
    sha256 cellar: :any, big_sur:      "231660b6371a8e2466e6144f1af344530d65d0e4fa3dad5cec72046568acb945"
    sha256               x86_64_linux: "bc2ba257934b50e2f81e08501260b104f9875d663f2e016e594c8dc88075ffd7"
  end

  depends_on "asciidoc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "meson", "b", "--prefix", prefix
    system "ninja", "-C", "b"
    system "ninja", "-C", "b", "install"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
