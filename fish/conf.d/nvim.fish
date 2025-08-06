# neovim
alias vim='nvim'
alias v='nvim'
alias vimdiff='nvim -d'
alias view='nvim -R'

# use vim as man pager
set -x MANPAGER 'nvim +Man!'

set -g fish_user_paths "/usr/local/nvim-macos/bin/" $fish_user_paths
