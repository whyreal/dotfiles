set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.utf-8"
set -x EDITOR 'nvim'
set -x HOMEBREW_NO_ANALYTICS 1

alias rmt='trash'
alias c='code .'
alias r='open -R'
alias d='cd ~/Documents/DocBase/ && $EDITOR index.js'

alias ....='cd ../../..'
alias ...='cd ../..'

alias grep='grep --color'
alias ldd='otool -L'

# PATH
set -g fish_user_paths "/opt/homebrew/bin/"            $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin"            $fish_user_paths
set -g fish_user_paths "/usr/local/sbin"                    $fish_user_paths
set -g fish_user_paths "$HOME/code/whyreal/dotfiles/scripts/"            $fish_user_paths

fish_add_path /opt/homebrew/opt/mysql-client@8.0/bin
fish_add_path /opt/homebrew/opt/ansible@9/bin
fish_add_path ~/Applications/rclone-v1.69.3-osx-arm64/

fzf --fish | source

set -x _ZO_FZF_OPTS "--bind=ctrl-z:ignore --exit-0 --height=40% --inline-info --no-sort --reverse --select-1"
zoxide init fish | source
function z
    if test -z $argv[1]
        __zoxide_zi
    else
        __zoxide_z $argv
    end
end

nvm use lts/jod -s

#fish_vi_key_bindings
