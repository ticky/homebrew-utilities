cask "aaru" do
  version "5.3.2"
  sha256 "763a531b7146ada04e26108f736be9d839dd405f50a6d3afb6591abe67b6292c"

  url "https://github.com/aaru-dps/Aaru/releases/download/v#{version}/aaru-#{version}_macos.zip"
  name "Aaru"
  desc "Fully featured media dump management solution"
  homepage "https://github.com/aaru-dps/Aaru"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "aaru"

  zap trash: "~/Library/Preferences/com.claunia.aaru.plist"

  def caveats
    <<~EOS
      Due to how dependencies are loaded, Aaru may fail to run unless installed with the `--no-quarantine` flag set.
    EOS
  end
end
