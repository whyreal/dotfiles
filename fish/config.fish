# set -e fish_user_paths
set -x LANG "en_US.UTF-8"
set -x EDITOR 'nvim'

# use vi mode
#fish_vi_key_bindings
# back to emacs mode
#fish_default_key_bindings

#alias ssl.certbot='sudo certbot certonly --manual'
alias rm='trash'
alias c='code'
alias v='nvim'
alias r='open -R'
alias d='cd ~/Documents/DocBase/ && $EDITOR'
alias m='make'

alias ....='cd ../../..'
alias ...='cd ../..'

alias pwgen='pwgen -r0oOiIlL'
alias grep='grep --color'
alias ldd='otool -L'
alias sqlplus='rlwrap sqlplus'
#alias telnet='nc -vz -w 1'

# PATH
set -g fish_user_paths "/usr/local/sbin"                  $fish_user_paths
#set -g fish_user_paths "/Applications/instantclient_18_1" $fish_user_paths
set -g fish_user_paths "/usr/local/apache-maven-3.8.3/bin/" $fish_user_paths
set -g fish_user_paths "$HOME/.yarn/bin" $fish_user_paths
#set -g fish_user_paths "/usr/local/helix/" $fish_user_paths
#set -g fish_user_paths "/usr/local/ltex-ls/bin/" $fish_user_paths

fish_add_path /usr/local/opt/llvm/bin
