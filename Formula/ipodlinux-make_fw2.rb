class IpodlinuxMakeFw2 < Formula
  desc "Installer for the iPodLinux loader"
  homepage "https://github.com/iPodLinux/ipl-installer2"
  url "https://github.com/iPodLinux/iPodLinux-SVN.git", revision: "ba84c982169450085392334c929416ee7237c7ae"
  version "2015-06-14T342139Z"
  revision 1

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/ipodlinux-make_fw2-2015-06-14T342139Z_1"
    sha256 cellar: :any_skip_relocation, catalina:     "dd6fb10c967b948120b54bb802cbf1c3df7c032664635b49a6eefa5ef6fedebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c05fe7f39b3cde8afdd43c3ebe70e22991fdea2245eaadef2e74c55256ddcaeb"
  end

  def install
    cd "apps/desktop/installer2" do
      inreplace "make_fw2.c", "./make_fw", "ipodlinux-make_fw2"
      inreplace "make_fw2.c", "    make_fw", "    ipodlinux-make_fw2"
      inreplace "make_fw2.c", "make_fw is", "ipodlinux-make_fw2 is"

      # Manually adapring the compiler stuff from the Makefile because
      # this is literally a two-file program and I don't want to fuck with it
      system ENV.cc, "-Wall", "-O2", "-o", "make_fw2", "make_fw2.c"
      bin.install "make_fw2" => "ipodlinux-make_fw2"
    end
  end
end
