class RtmpNginx < Formula
  desc "RTMP server"
  homepage "https://nginx.org/"
  url "https://nginx.org/download/nginx-1.13.9.tar.gz"
  sha256 "5faea18857516fe68d30be39c3032bd22ed9cf85e1a6fdf32e3721d96ff7fa42"
  head "https://hg.nginx.org/nginx/", :using => :hg

  resource "nginx-rtmp-module" do
    url "https://github.com/arut/nginx-rtmp-module.git", :revision => "791b6136f02bc9613daf178723ac09f4df5a3bbf"
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    # Configures to just be a nice RTMP server
    File.open("conf/nginx.conf", "w") do |f|
      f.puts <<~RTMP
        worker_processes 1;

        events {
            worker_connections 1024;
        }

        http {
          include mime.types;
          default_type application/octet-stream;

          sendfile on;

          keepalive_timeout 65;

          gzip on;

          server {
            listen 1936;

            location / {
              rtmp_stat all;

              # Use this stylesheet to view XML as web page
              # in browser
              rtmp_stat_stylesheet /rtmp-nginx-stat.xsl;
            }

            location /control {
              rtmp_control all;
            }

            location /rtmp-nginx-stat.xsl {
              # XML stylesheet to view RTMP stats.
              # Copy stat.xsl wherever you want
              # and put the full directory path here
              root #{pkgshare}/rtmp-nginx;
            }
          }
        }

        rtmp {
          server {
            listen 1935;
            buflen 0;

            application stream {
              # enable live streaming
              live on;
            }
          }
        }
      RTMP
    end

    openssl = Formula["openssl"]
    pcre = Formula["pcre"]

    cc_opt = "-I#{pcre.opt_include} -I#{openssl.opt_include}"
    ld_opt = "-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

    resource("nginx-rtmp-module").stage do
      (buildpath/"nginx-rtmp-module").install Dir["*"]
    end

    args = %W[
      --prefix=#{prefix}
      --sbin-path=#{bin}/rtmp-nginx
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --conf-path=#{etc}/rtmp-nginx/nginx.conf
      --pid-path=#{var}/run/rtmp-nginx.pid
      --lock-path=#{var}/run/rtmp-nginx.lock
      --http-client-body-temp-path=#{var}/run/rtmp-nginx/client_body_temp
      --http-proxy-temp-path=#{var}/run/rtmp-nginx/proxy_temp
      --http-fastcgi-temp-path=#{var}/run/rtmp-nginx/fastcgi_temp
      --http-uwsgi-temp-path=#{var}/run/rtmp-nginx/uwsgi_temp
      --http-scgi-temp-path=#{var}/run/rtmp-nginx/scgi_temp
      --http-log-path=#{var}/log/rtmp-nginx/access.log
      --error-log-path=#{var}/log/rtmp-nginx/error.log
      --with-debug
      --add-module=#{buildpath}/nginx-rtmp-module
    ]

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end

    system "make", "install"

    pkgshare.install "nginx-rtmp-module/stat.xsl" => "rtmp-nginx-stat.xsl"
  end

  def post_install
    (var/"run/rtmp-nginx").mkpath
  end

  plist_options :manual => "rtmp-nginx"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/rtmp-nginx</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"nginx.conf").write <<~EOS
      worker_processes 4;
      error_log #{testpath}/error.log;
      pid #{testpath}/nginx.pid;
      events {
        worker_connections 1024;
      }
      http {
        client_body_temp_path #{testpath}/client_body_temp;
        fastcgi_temp_path #{testpath}/fastcgi_temp;
        proxy_temp_path #{testpath}/proxy_temp;
        scgi_temp_path #{testpath}/scgi_temp;
        uwsgi_temp_path #{testpath}/uwsgi_temp;
        server {
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    EOS
    system bin/"rtmp-nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
