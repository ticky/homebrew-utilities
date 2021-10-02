cask "aaru" do
  version "5.3.0"
  sha256 "7348a8314ddf23041c30942458ef5f06717c5501ec290cc7b0ab09d19370cb96"

  url "https://github.com/aaru-dps/Aaru/releases/download/v#{version}/aaru-#{version}_macos.zip"
  name "Aaru"
  desc "Fully featured media dump management solution"
  homepage "https://github.com/aaru-dps/Aaru"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "aaru"

  zap trash: [
    "~/Library/Preferences/com.claunia.aaru.plist",
  ]

  def caveats
    <<~EOS
      Due to how dependencies are loaded, Aaru may fail to run unless installed with the `--no-quarantine` flag set.
    EOS
  end
end
