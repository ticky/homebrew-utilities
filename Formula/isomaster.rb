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

  depends_on "gtk+"

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
