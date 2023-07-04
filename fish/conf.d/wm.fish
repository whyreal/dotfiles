#alias tmux='command tmux attach || command tmux'
alias w='tmux'
alias wns='tmux new -s'
alias wa='tmux a'
alias wls='tmux ls'
alias wns='tmux new-session -s'

set -x TMUX_FZF_SED "gsed"
