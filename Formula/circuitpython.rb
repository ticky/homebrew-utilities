class Circuitpython < Formula
  desc "Python implementation for teaching coding with microcontrollers"
  homepage "https://circuitpython.org/"
  url "https://github.com/adafruit/circuitpython.git", tag: "6.3.0"

  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/ticky/homebrew-utilities/releases/download/circuitpython-6.3.0"
    sha256 cellar: :any, catalina: "00dd71ee16ec6a80b879862c8bd5b0e345cc469c95a37a57b07f3d9a968ecfb1"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on :macos
  depends_on "python@3.8" # Requires python3 executable

  conflicts_with "micropython",
                 because: "circuitpython is a fork of micropython, and they have the same executable names"

  def install
    system "make", "-C", "mpy-cross"

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
