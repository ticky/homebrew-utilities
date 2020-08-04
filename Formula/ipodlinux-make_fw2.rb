class IpodlinuxMakeFw2 < Formula
  desc "iPodLinux loader installer"
  homepage "https://github.com/iPodLinux/ipl-installer2"
  url "https://github.com/iPodLinux/iPodLinux-SVN.git", revision: "ba84c982169450085392334c929416ee7237c7ae"
  version "2015-06-14T04:21:39Z"

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
