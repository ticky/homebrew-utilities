class Icd < Formula
  desc "Simple CLI interface for fetching file and folder from the iCloud Storage"
  homepage "https://github.com/farnots/iCloudDownloader"
  url "https://github.com/farnots/iCloudDownloader.git", revision: "74491c772500161079feccf3d7b5ba367fcf4420"
  version "1.0-ticky.1"
  head "https://github.com/farnots/iCloudDownloader.git"

  depends_on :macos
  depends_on xcode: "9.3"

  def install
    xcodebuild "-project", "iCloudDownlader.xcodeproj",
               "-target", "iCloudDownlader",
               "-configuration", "Release",
               "-sdk", "macosx",
               "SYMROOT=build",
               "OBJROOT=build"

    bin.install "build/Release/iCloudDownlader" => "icd"
  end
end
