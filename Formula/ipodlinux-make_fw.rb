class IpodlinuxMakeFw < Formula
  desc "Installer for the iPodLinux loader"
  homepage "https://github.com/iPodLinux/iPodLinux-SVN/tree/master/legacy/ipodloader"
  url "https://raw.githubusercontent.com/iPodLinux/iPodLinux-SVN/000419cf0b4c280383e19e993982649e14663378/legacy/ipodloader/make_fw.c"
  version "2007-08-28T373407Z"
  sha256 "acf48e7a1bb48bdf16b4caadabf78c0d593051430a73ed5da5c2ce4d2ccdcff5"
  revision 1
  head "https://raw.githubusercontent.com/iPodLinux/iPodLinux-SVN/master/legacy/ipodloader/make_fw.c"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/ipodlinux-make_fw-2007-08-28T373407Z_1"
    cellar :any_skip_relocation
    sha256 "4aa0a301cdb5a1b247482e44cfe39f4c7bc1796ab22083ca1ffbea1dc557fa14" => :catalina
    sha256 "ffdae8f96463d0e825808227084c72b7b859488d970ab80627c2ac4c77312191" => :x86_64_linux
  end

  def install
    inreplace "make_fw.c", "make_fw", "ipodlinux-make_fw"

    # Manually copying the compiler stuff from the Makefile because
    # this is literally a one-file program and I don't want to fuck with it
    system ENV.cc, "-Wall", "-O2", "-o", "make_fw", "make_fw.c"
    bin.install "make_fw" => "ipodlinux-make_fw"
  end
end
