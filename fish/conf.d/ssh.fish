alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'

function s 
    rsync --delete -rp ~/Documents/DocBase/work/commands/remote/xbin $argv[1]:/tmp/ \
    && rsync --delete -rp ~/Documents/DocBase/work/commands/remote/nvim $argv[1]:.config/ \
    && rsync -r ~/Documents/DocBase/work/commands/remote/server_utils.sh $argv[1]:/etc/profile.d/ \
    && ssh $argv
end
