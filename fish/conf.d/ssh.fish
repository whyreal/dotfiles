alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'

function s  --wraps "ssh"
    set -l scriptRoot ~/Documents/DocBase/work/commands/xbin

    set -l options --chmod=ugo=rwX

    rsync --delete -rp $options $scriptRoot $argv[1]:/tmp/ \
    && ssh $argv /tmp/xbin/x.init \
    && ssh $argv
end
