#function ssh
#  if set -q TMUX
#      #tmux rename-window (echo $argv | cut -d . -f 1)
#    tmux select-pane -T "$argv[-1]"
#  end
#    command ssh "$argv"
#end
#
alias s='ssh'
alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'

