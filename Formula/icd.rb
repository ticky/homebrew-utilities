class Icd < Formula
  desc "A simple CLI interface for fetching file and folder from the iCloud Storage"
  homepage "https://github.com/farnots/iCloudDownloader"
  url "https://github.com/farnots/iCloudDownloader.git", :tag => "v1.0"
  head "https://github.com/farnots/iCloudDownloader.git"

  depends_on :xcode => "9.3"

  def install
    xcodebuild "-project", "iCloudDownlader.xcodeproj", "-target", "iCloudDownlader",
               "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/iCloudDownlader" => "icd"
  end
end
