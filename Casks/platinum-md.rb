cask "platinum-md" do
  version "1.2.0"
  sha256 "67cd371d85445981ae208b85841779d326876b6c40b74cdcee80d5405761deb5"

  url "https://github.com/gavinbenda/platinum-md/releases/download/v#{version}/platinum-md-#{version}.dmg",
      verified: "github.com/gavinbenda/platinum-md/releases"
  name "Platinum-MD"
  desc "Minidisc NetMD Conversion and Upload"
  homepage "https://platinum-md.app/"

  livecheck do
    url :homepage
    regex(%r{href="https://github\.com/gavinbenda/platinum-md/releases/download/v(\d+(?:\.\d+)+)/}i)
  end

  depends_on formula: "glib"
  depends_on formula: "json-c"
  depends_on formula: "libgcrypt"
  depends_on formula: "libid3tag"
  depends_on formula: "libtag"
  depends_on formula: "libusb"
  depends_on formula: "libusb-compat"

  app "platinum-md.app"

  uninstall quit: [
    "com.gavinbenda.platinum-md",
    "com.gavinbenda.platinum-md.helper",
  ]

  zap trash: [
    "~/Library/Application Support/platinum-md",
    "~/Library/Preferences/com.gavinbenda.platinum-md.helper.plist",
    "~/Library/Preferences/com.gavinbenda.platinum-md.plist",
    "~/Library/Saved Application State/com.gavinbenda.platinum-md.savedState",
  ]
end
