class Pcem < Formula
  desc "IBM PC emulator"
  homepage "http://pcem-emulator.co.uk"
  url "https://github.com/sarah-walker-pcem/pcem.git", revision: "13f53a25687be71ee3ee8482b1a90b1b0aa64fb6"
  version "17"

  head "https://github.com/sarah-walker-pcem/pcem.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "sdl2"
  depends_on "wxmac"

  patch :DATA

  def install
    ENV.append "LDFLAGS", "-framework OpenGL"
    system "autoreconf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

# Patch for config.guess based on Autoconf: http://git.savannah.gnu.org/gitweb/?p=config.git;a=blobdiff;f=config.guess;h=e94095c5fbe89c77bfb99903f66223e4ef856e86;hp=92bfc33e2962a5837b25f736d8ded00ae4bf81a5;hb=2593751ef276497e312d7c4ce7fd049614c7bf80;hpb=b2969c6e71c928b0428b55b81666fb8899c81ac1
__END__
diff --git a/config.guess b/config.guess
index 6c32c86..646bde1 100755
--- a/config.guess
+++ b/config.guess
@@ -1255,6 +1255,9 @@ EOF
     *:Rhapsody:*:*)
 	echo ${UNAME_MACHINE}-apple-rhapsody${UNAME_RELEASE}
 	exit ;;
+    arm64:Darwin:*:*)
+	echo aarch64-apple-darwin"$UNAME_RELEASE"
+	exit ;;
     *:Darwin:*:*)
 	UNAME_PROCESSOR=`uname -p` || UNAME_PROCESSOR=unknown
 	eval $set_cc_for_build
diff --git a/src/Makefile.am b/src/Makefile.am
index 8197093..e8f0b9f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -137,7 +137,7 @@ pcem_LDADD += wx.res
 endif
 
 if !HAS_OFF64T
-#pcem_CFLAGS += -Doff64_t=off_t -Dfopen64=fopen -Dfseeko64=fseek -Dftello64=ftell
+pcem_CFLAGS += -Doff64_t=off_t -Dfopen64=fopen -Dfseeko64=fseek -Dftello64=ftell
 endif
 
 if RELEASE_BUILD
