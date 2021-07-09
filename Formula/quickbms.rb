class Quickbms < Formula
  desc "Generic file extractor and reimporter"
  homepage "https://aluigi.altervista.org/quickbms.htm"
  url "https://aluigi.altervista.org/papers/quickbms-src-0.11.0.zip"
  sha256 "4136b4273c3af44f4b90ad094a52610738f7e5531231075a17d87f0fa0a4d51e"

  depends_on "gcc" => :build
  depends_on "openssl"

  fails_with :clang

  def install
    if Hardware::CPU.arm?
      # GCC's stack protector doesn't seem to work on darwin-aarch64 for some reason
      # See also: https://github.com/NixOS/nixpkgs/pull/128606
      inreplace "Makefile", "-fstack-protector-all ", ""

      # Force things to detect aarch64 as 64-bit
      inreplace "compression/prelude.h",
                "#if (defined (__64BIT__) || defined (__x86_64__))",
                "#if (defined (__64BIT__) || defined (__x86_64__) || defined (__aarch64__))"
      inreplace "libs/tornado/Common.h",
                "#if defined(_M_X64) || defined(_M_AMD64) || defined(__x86_64__)",
                "#if defined(_M_X64) || defined(_M_AMD64) || defined(__x86_64__)|| defined (__aarch64__)"
    end

    system "make", "V=1", "PREFIX_OPENSSL=#{Formula["openssl"].opt_prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Taken from the sample at http://aluigi.altervista.org/bms/quickbms_crc_engine.txt
    (testpath/"crc.bms").write <<~EOS
      encryption CRC 0xEDB88320 "32 -1 -1 0 0 1"
      get SIZE asize
      log MEMORY_FILE 0 SIZE
      print "%QUICKBMS_CRC|x%"
    EOS

    (testpath/"test.txt").write "Test data\n"

    assert_includes `#{bin}/quickbms crc.bms test.txt 2>&1`, "0x5836df4d"
  end
end
