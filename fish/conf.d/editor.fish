# neovim
alias vim='nvim'
alias e='nvim'
alias vimdiff='nvim -d'

# use vim as man pager
set -x MANPAGER 'nvim +Man!'

set -g fish_user_paths "/usr/local/nvim-macos/bin/" $fish_user_paths
