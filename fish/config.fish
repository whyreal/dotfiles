set -x LANG "en_US.UTF-8"
set -x EDITOR 'nvim'

set -x HOMEBREW_NO_ANALYTICS 1

alias rm='trash'
alias c='code'
alias e='nvim'
alias r='open -R'
alias d='cd ~/Documents/DocBase/ && $EDITOR'
alias fm='joshuto'

alias ....='cd ../../..'
alias ...='cd ../..'

alias pwgen='pwgen -r0oOiIlL'
alias grep='grep --color'
alias ldd='otool -L'
alias sqlplus='rlwrap sqlplus'

# PATH
set -g fish_user_paths "/usr/local/opt/curl/bin"            $fish_user_paths
set -g fish_user_paths "/usr/local/sbin"                    $fish_user_paths
set -g fish_user_paths "/usr/local/apache-maven-3.8.3/bin/" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/llvm/bin"            $fish_user_paths
set -g fish_user_paths "$HOME/.yarn/bin"                    $fish_user_paths
