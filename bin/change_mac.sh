#!/bin/bash

if [ $# -eq 1 ];then
    dev=$1
else
    dev="en0"
fi

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport --disassociate
sudo ifconfig $dev ether $(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/./0/2; s/.$//')
networksetup -detectnewhardware