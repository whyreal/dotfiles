function x.proxy.deactive
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    set -ge http_proxy
    set -ge https_proxy
end
