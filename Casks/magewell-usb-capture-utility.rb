cask "magewell-usb-capture-utility" do
  version "3.0.3.4202"
  sha256 "77fbdf1e8653eaf380a848cda2f9c28f8005ff117fd4934bec5084ba93d3c197"

  url "http://www.magewell.com/files/tools/USBCaptureUtility3_macOS_#{version.split(".").last}.zip"
  name "Magewell USB Capture Utility"
  desc "Software for Magewell USB Capture and USB Capture Plus devices"
  homepage "http://www.magewell.com/usb-capture-utility-v3"

  livecheck do
    url "http://www.magewell.com/downloads/usb-capture-plus#/tools/mac-x86"
    regex(/V(\d+\.\d+(?:\.\d+)+)/i)
  end

  container nested: "USBCaptureUtility_#{version}Intenal.dmg"

  app "USBCaptureUtility.app"

  uninstall quit: [
    "com.magewell.USBCaptureUtility",
  ]

  zap trash: [
    "~/Library/Saved Application State/com.magewell.USBCaptureUtility.savedState",
  ]
end
