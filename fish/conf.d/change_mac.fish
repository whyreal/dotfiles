#!/usr/bin/env fish

function change_mac
    if test "$(count $argv)" -eq 0
        set dev en0
    else
        set dev $argv[1]
    end

    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport --disassociate
    echo sudo ifconfig $dev ether $(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
    networksetup -detectnewhardware
end
