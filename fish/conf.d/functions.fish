function proxy.ss.active
    git config --global http.proxy  "socks5://127.0.0.1:1081"
    git config --global https.proxy "socks5://127.0.0.1:1081"
    set -gx http_proxy "http://127.0.0.1:1087"
    set -gx https_proxy "http://127.0.0.1:1087"
end

function proxy.ss.deactive
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    set -ge http_proxy
    set -ge https_proxy
end

function ssh.execute_local_script
    if test -z $argv[1]
        echo "$_ host script"
        return 1
    end
    set -l host $argv[1]
    set -l script $argv[2]
    cat $script | ssh -T $host
end

function copy_remote_screen_exchange_content_to_local_clipboard
    ssh $argv[1] cat /tmp/screen-exchange | pbcopy
end
function vpn.route.add.zkzy
    sudo route -n add 192.168.80/22 -interface ppp0
end
function vpn.route.del.zkzy
    sudo route -n delete 192.168.80/22 -interface ppp0
end
function safari.agent.ipad
    defaults write com.apple.Safari CustomUserAgent "'Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3'"
end
function safari.agent.default
    defaults delete com.apple.Safari CustomUserAgent
end
function oracle.env.gb2312
    echo export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
end

function wscurl
    curl \
    --include \
    --no-buffer \
    --header "Connection: Upgrade" \
    --header "Upgrade: websocket" \
    --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
    --header "Sec-WebSocket-Version: 13" \
    $argv # all arguments
end
