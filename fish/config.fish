set -e fish_user_paths
set -x EDITOR 'nvim'

# use vi mode
#fish_vi_key_bindings
# back to emacs mode
#fish_default_key_bindings

# git
alias g='vim +Git'

alias rm='trash -F'
alias cat='bat'
alias r='open -R'
alias e='open -e'
alias s='ssh'
alias d='cd ~/Documents/DocBase/ && $EDITOR'
alias o='open'
alias drawio='open -a draw.io.app'

alias ....='cd ../../..'
alias ...='cd ../..'

alias pwgen='pwgen -r0oOiIlL'
alias grep='grep --color'
alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'
# use mycli
alias mysql='mycli'
# alias mysql='mysql --default-auth=mysql_native_password'
# alias mysql8='command mysql'
alias mysqldump='mysqldump --column-statistics=0'
alias mysqldump8='command mysqldump'
alias tl='python3 ~/code/translator/translator.py'
alias ldd='otool -L'
alias secp='copy_remote_screen_message_content_to_local_clipboard'
alias sqlplus='rlwrap sqlplus'
#alias telnet='nc -vz -w 1'
alias tmux='command tmux attach || command tmux'

set -x LANG "en_US.UTF-8"

# golang
set -g fish_user_paths "$HOME/go/bin/" $fish_user_paths
set -x GOPATH /Users/Real/go
set -x GO111MODULE on # Enable the go modules feature
set -x GOPROXY https://goproxy.cn #Set the GOPROXY environment variable

# python
# pyenv https://github.com/pyenv/pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
set -g fish_user_paths $PYENV_ROOT/bin $fish_user_paths
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source

# neovim
set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
alias vim='nvim'
alias v='nvim'

# use vim as man pager
set -x MANPAGER 'nvim +Man!'

# PATH
set -g fish_user_paths "/usr/local/sbin"                  $fish_user_paths
set -g fish_user_paths "/Users/Real/code/projects/scripts/"    $fish_user_paths
set -g fish_user_paths "/usr/local/opt/mysql-client/bin"  $fish_user_paths
set -g fish_user_paths "/Applications/instantclient_18_1" $fish_user_paths
set -g fish_user_paths "/usr/local/apache-maven-3.8.3/bin/" $fish_user_paths
set -g fish_user_paths "$HOME/.yarn/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.config/yarn/global/node_modules/.bin" $fish_user_paths
set -g fish_user_paths "/Users/Real/Library/Python/3.9/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/nvim-osx64/bin/" $fish_user_paths
set -g fish_user_paths "/usr/local/rclone/" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/ncurses/bin" $fish_user_paths

fish_add_path /usr/local/opt/llvm/bin
