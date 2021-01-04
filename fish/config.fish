alias r='open -R'
alias e='open -e'
alias o='open'
alias o.notes='cd ~/Documents/vim-workspace/docs && $EDITOR'
alias drawio='open -a draw.io.app'

alias ....='cd ../../..'
alias ...='cd ../..'

alias pwgen='pwgen -r0oOiIlL'
alias grep='grep --color'
alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'
alias mysql='mysql --default-auth=mysql_native_password'
alias mysql8='command mysql'
alias mysqldump='mysqldump --column-statistics=0'
alias mysqldump8='command mysqldump'
alias tl='python3 ~/code/translator/translator.py'
alias ldd='otool -L'
alias secp='copy_remote_screen_message_content_to_local_clipboard'
alias sqlplus='rlwrap sqlplus'
alias telnet='nc -vz -w 1'

export EDITOR='nvim'

set -x LANG "en_US.UTF-8"

set -x FZF_DEFAULT_OPTS "--extended --cycle"
set -x FZF_DEFAULT_COMMAND 'fd -i -I -L -H -E .git -E .svn --type f'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# golang
set -g fish_user_paths "$HOME/go/bin/" $fish_user_paths
set -x GOPATH /Users/Real/go
set -x GO111MODULE on # Enable the go modules feature
set -x GOPROXY https://goproxy.cn #Set the GOPROXY environment variable

# lua
alias luarocks='luarocks --lua-dir=/usr/local/opt/lua@5.1'

# neovim
set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
alias vim='nvim'

# use vim as man pager
set -x MANPAGER 'nvim +Man!'

set -g fish_user_paths "/usr/local/sbin"                  $fish_user_paths
set -g fish_user_paths "$HOME/Documents/Note/scripts/"    $fish_user_paths
set -g fish_user_paths "/usr/local/opt/mysql-client/bin"  $fish_user_paths
set -g fish_user_paths "/Applications/instantclient_18_1" $fish_user_paths

set -g fish_user_paths "/usr/local/apache-maven-3.6.3/bin/" $fish_user_paths

# nodejs
set -g fish_user_paths "$HOME/.yarn/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.config/yarn/global/node_modules/.bin" $fish_user_paths

# python
set -g fish_user_paths "/Users/Real/Library/Python/3.8/bin" $fish_user_paths

# rustlang
set -g fish_user_paths "$HOME/.cargo/bin" $fish_user_paths

# neovim
set -g fish_user_paths "/usr/local/nvim-osx64/bin/" $fish_user_paths

function proxy.ss.active
    git config --global http.proxy 127.0.0.1:1087
    #git config --local http.proxy 127.0.0.1:1087
    set -x http_proxy "http://127.0.0.1:1087"
    set -x https_proxy "http://127.0.0.1:1087"
end
function proxy.ss.deactive
    git config --global --unset http.proxy
    #git config --local --unset http.proxy
    set -x http_proxy ""
    set -x https_proxy ""
end
function ssh.execute_local_script
    if test -z $argv[1]
        echo "$_ host script"
        return 1
    end
    set -l host $argv[1]
    set -l script $argv[2]
    cat $script | ssh -T $host
end
function copy_remote_screen_exchange_content_to_local_clipboard
    ssh $argv[1] cat /tmp/screen-exchange | pbcopy
end
function vpn.route.add.zkzy
    sudo route -n add 192.168.80/24 -interface ppp0
end
function vpn.route.del.zkzy
    sudo route -n delete 192.168.80/24 -interface ppp0
end
function safari.agent.ipad
    defaults write com.apple.Safari CustomUserAgent "'Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3'"
end
function safari.agent.default
    defaults delete com.apple.Safari CustomUserAgent
end
function oracle.env.gb2312
    echo export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
end

function z
    if test -z $argv[1]
        _zlua -I .
    else
        _zlua -I $argv
    end
end
set -g fish_user_paths "/usr/local/opt/curl/bin" $fish_user_paths
