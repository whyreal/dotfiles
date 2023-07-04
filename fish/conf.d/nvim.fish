# neovim
set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
alias vim='nvim'
alias v='nvim'
alias vimdiff='nvim -d'

# use vim as man pager
set -x MANPAGER 'nvim +Man!'

set -g fish_user_paths "/usr/local/nvim-macos/bin/" $fish_user_paths
