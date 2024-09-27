#!/usr/local/bin/fish

if test $(count $argv) -eq 0
    echo "---- give me a name -------"
    exit 0;
end

set name $argv[1]

umask 077
wg genkey > $name.key
echo "======= $name priv key =========="
cat $name.key

wg pubkey < $name.key > $name.pub
echo "======= $name pub key =========="
cat $name.pub
