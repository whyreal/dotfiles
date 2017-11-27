#!/bin/bash

action=
iprange=

usage(){
    echo "$0 [start|stop] project"
    echo "project: wjs, zkzy"
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

if [[ $1 == 'start' ]];then
    action='add'
elif [[ $1 == 'stop' ]];then
    action='delete'
fi

if [[ $2 == 'wjs' ]];then
    iprange='129.1/16 129.0/16'
    gw='192.168.56.101'
elif [[ $2 == 'zkzy' ]];then
    iprange='192.168.80/24'
    gw='192.168.90.249'
fi

for i in $iprange;do
    sudo route -n $action $i $gw
done
