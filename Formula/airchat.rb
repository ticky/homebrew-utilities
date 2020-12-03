class Airchat < Formula
  desc "Lets you chat to nearby users by abusing the AirDrop interface on OS X"
  homepage "https://github.com/chendo/airchat"
  url "https://github.com/chendo/airchat.git", revision: "d0da3bec0d94b88bf8a990bbebbd7703ced5fc12"
  version "2016-12-11T354211Z"
  revision 1

  head "https://github.com/chendo/airchat.git"

  depends_on :macos

  def install
    inreplace "airchat.rb", "./airchat.rb", "airchat"
    bin.install "airchat.rb" => "airchat"
  end
end
