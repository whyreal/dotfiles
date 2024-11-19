set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.utf-8"

set -x EDITOR 'nvim'

set -x HOMEBREW_NO_ANALYTICS 1

set -x OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES

alias luamake="/Users/Real/code/GitHub/luamake/luamake"
alias rmt='trash'
alias c='code .'
alias r='open -R'
alias d='cd ~/Documents/DocBase/ && $EDITOR index.js'
#alias fm='joshuto'
alias 7z='7z -xr"!.DS_Store"'

alias ....='cd ../../..'
alias ...='cd ../..'

alias grep='grep --color'
alias ldd='otool -L'
#alias sqlplus='rlwrap sqlplus'

# PATH
set -g fish_user_paths "/usr/local/opt/gnu-tar/libexec/gnubin"            $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin"            $fish_user_paths
set -g fish_user_paths "/usr/local/sbin"                    $fish_user_paths
set -g fish_user_paths "/usr/local/apache-maven-3.8.3/bin/" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/llvm/bin"            $fish_user_paths
set -g fish_user_paths "$HOME/code/whyreal/dotfiles/scripts/"            $fish_user_paths
fish_add_path /usr/local/opt/mysql-client@8.0/bin

set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/graalvm-jdk-21.0.4+8.1/Contents/Home"
set -g fish_user_paths "/Library/Java/JavaVirtualMachines/graalvm-jdk-21.0.4+8.1/Contents/Home/bin/" $fish_user_paths

nvm use lts/iron -s
