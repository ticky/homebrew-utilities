cask "aaru" do
  version "5.2.0.3330"
  sha256 "e6c2c777c231195eb227b93b3149a393bb560a9c535a456d9335226d98255b22"

  url "https://github.com/aaru-dps/Aaru/releases/download/v#{version}/aaru-#{version}-1_macos.zip"
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
