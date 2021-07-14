class Isomaster < Formula
  desc "Simple CLI interface for fetching file and folder from the iCloud Storage"
  homepage "http://littlesvr.ca/isomaster/"
  url "http://littlesvr.ca/isomaster/releases/isomaster-1.3.16.tar.bz2"
  sha256 "dfe6e4d7e46eced7b51d263e568fb7d6c5b781d62476d6ed4715269c6626b0c6"
  license "GPL-2.0-only"

  livecheck do
    url "http://littlesvr.ca/isomaster/download/"
    regex(%r{isomaster/releases/isomaster-(\d+(?:\.\d+)+).t}i)
  end

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/isomaster-1.3.16"
    sha256 catalina:     "09b3eb4c8a8853979537d85c67babf4496d17ce3521378e0de68ed42f29bf0a6"
    sha256 x86_64_linux: "df47bed8bce3bc18f5de1da6931c9a33ca20b505a4771f49da80ffa6a446b6f4"
  end

  depends_on "gtk+"
  depends_on "iniparser"

  def install
    ENV["PREFIX"] = prefix
    ENV["DEFAULT_EDITOR"] = "open"
    ENV["DEFAULT_VIEWER"] = "open"
    ENV["USE_SYSTEM_INIPARSER"] = "true"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage: isomaster [image.iso]",
                 shell_output("#{bin}/isomaster --help")
  end
end
