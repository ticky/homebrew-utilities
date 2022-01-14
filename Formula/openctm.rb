class Openctm < Formula
  desc "File format, library and tool set for compression of 3D triangle meshes"
  homepage "https://openctm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/openctm/OpenCTM-1.0.3/OpenCTM-1.0.3-src.tar.bz2"
  sha256 "4a8d2608d97364f7eec56b7c637c56b9308ae98286b3e90dbb7413c90e943f1d"

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/openctm-1.0.3"
    sha256 cellar: :any, big_sur: "14903dc4512d44b3ee48c92f85c391f88a2c5e3eaa806d9a94ae423648a808e2"
  end

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

  test do
    # Cube model, from https://people.sc.fsu.edu/~jburkardt/data/obj/obj.html
    (testpath/"cube.obj").write <<~EOS
      v  0.0  0.0  0.0
      v  0.0  0.0  1.0
      v  0.0  1.0  0.0
      v  0.0  1.0  1.0
      v  1.0  0.0  0.0
      v  1.0  0.0  1.0
      v  1.0  1.0  0.0
      v  1.0  1.0  1.0

      vn  0.0  0.0  1.0
      vn  0.0  0.0 -1.0
      vn  0.0  1.0  0.0
      vn  0.0 -1.0  0.0
      vn  1.0  0.0  0.0
      vn -1.0  0.0  0.0

      f  1//2  7//2  5//2
      f  1//2  3//2  7//2
      f  1//6  4//6  3//6
      f  1//6  2//6  4//6
      f  3//3  8//3  7//3
      f  3//3  4//3  8//3
      f  5//5  7//5  8//5
      f  5//5  8//5  6//5
      f  1//4  5//4  6//4
      f  1//4  6//4  2//4
      f  2//1  6//1  8//1
      f  2//1  8//1  4//1
    EOS

    system bin/"ctmconv",
           testpath/"cube.obj",
           testpath/"cube.ctm"
  end
end
