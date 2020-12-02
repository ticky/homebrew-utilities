class IpodlinuxMakeFw < Formula
  desc "Installer for the iPodLinux loader"
  homepage "https://github.com/iPodLinux/iPodLinux-SVN/tree/master/legacy/ipodloader"
  url "https://raw.githubusercontent.com/iPodLinux/iPodLinux-SVN/000419cf0b4c280383e19e993982649e14663378/legacy/ipodloader/make_fw.c"
  version "2007-08-28T07:34:07Z"
  head "https://raw.githubusercontent.com/iPodLinux/iPodLinux-SVN/master/legacy/ipodloader/make_fw.c"

  def install
    inreplace "make_fw.c", "make_fw", "ipodlinux-make_fw"
    # Manually copying the compiler stuff from the Makefile because
    # this is literally a one-file program and I don't want to fuck with it
    system ENV.cc, "-Wall", "-O2", "-o", "make_fw", "make_fw.c"
    bin.install "make_fw" => "ipodlinux-make_fw"
  end
end
