function x.proxy.active
    git config --global http.proxy  "socks5://127.0.0.1:1081"
    git config --global https.proxy "socks5://127.0.0.1:1081"
    set -gx http_proxy "http://127.0.0.1:1087"
    set -gx https_proxy "http://127.0.0.1:1087"
end

