#!/usr/bin/env fish

set servers \
    bj-bkhc.192.168.0.29 \
    bj-bkhc.192.168.0.27 \
    bj-bkhc.192.168.0.26 \
    bj-bkhc.192.168.0.25 \
    bj-bkhc.192.168.0.24 \
    bj-bkhc.192.168.0.23 \
    bj-bkhc.192.168.0.22 \
    bj-bkhc.192.168.0.20 \
    bj-bkhc.192.168.0.11 \
    bj-bkhc.192.168.0.101 \
    zkzy.192.168.82.5 \
    zkzy.192.168.80.97 \
    zkzy.192.168.80.108 \
    zkzy.192.168.80.202

for s in $servers;
    echo
    echo $s
    echo "=========================="
    ssh $s '/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL | grep "Firmware state"'
    #ssh $s '/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL | grep -i err'
end


