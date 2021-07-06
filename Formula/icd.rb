class Icd < Formula
  desc "Simple CLI interface for fetching file and folder from the iCloud Storage"
  homepage "https://github.com/farnots/iCloudDownloader"
  url "https://github.com/farnots/iCloudDownloader.git", revision: "74491c772500161079feccf3d7b5ba367fcf4420"
  version "1.0-ticky.1"
  head "https://github.com/farnots/iCloudDownloader.git"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/icd-1.0-ticky.1"
    sha256 cellar: :any_skip_relocation, catalina: "56e302393bd7c64eb83c9b96dbb3b6bc16e2bcbdc08b75f630e24d153b50a009"
  end

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
