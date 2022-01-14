class Openctm < Formula
  desc "File format, library and tool set for compression of 3D triangle meshes"
  homepage "https://openctm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/openctm/OpenCTM-1.0.3/OpenCTM-1.0.3-src.tar.bz2"
  sha256 "4a8d2608d97364f7eec56b7c637c56b9308ae98286b3e90dbb7413c90e943f1d"

  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on :macos

  def install
    bin.mkpath
    include.mkpath
    lib.mkpath
    man.mkpath

    extension = if OS.linux?
      "linux"
    else
      "macosx"
    end

    system "make", "-f", "Makefile.#{extension}"
    system "make", "-f", "Makefile.#{extension}",
                         "LIBDIR=#{lib}",
                         "INCDIR=#{include}",
                         "BINDIR=#{bin}",
                         "MAN1DIR=#{man}",
                         "install"

    pkgshare.install "plugins"
  end

  def caveats
    <<~EOS
      Blender and Maya plugins are included in #{pkgshare/"plugins"},
      though they have not been tested with current versions of either.
    EOS
  end
end
