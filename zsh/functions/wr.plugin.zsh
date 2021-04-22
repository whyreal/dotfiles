# 环境变量 {{{1
# history
export HISTSIZE=5000
export HISTFILESIZE=50000
# WORDCHARS
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
# editor
export EDITOR='nvim'
# pager
#export PAGER='bat'
# use vim as man pager
export MANPAGER="command vim -u /dev/null -c 'MANPAGER' -c 'set fdm=indent ts=7 sw=7' -"

export LC_ALL="en_US.UTF-8"
#export LC_ALL="zh_CN.GB2312"
if [[ $LC_CTYPE = "zh_CN.eucCN" ]]; then
    export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
fi

# golang
export PATH=$PATH:$HOME/go/bin/
export GOPATH=/Users/Real/go
export GO111MODULE=on # Enable the go modules feature
export GOPROXY=https://goproxy.cn #Set the GOPROXY environment variable

# java
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_251.jdk/Contents/Home/
#export PATH=$JAVA_HOME/bin:$PATH
#export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-1.0.0-rc14/Contents/Home

export PATH=$PATH:$HOME/Documents/Note/scripts/
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/usr/local/opt/mysql-client/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$PATH:/Applications/instantclient_18_1

# oracle
export NLS_LANG=AMERICAN_AMERICA.UTF8

# fzf
export FZF_DEFAULT_OPTS="--extended --cycle"
export FZF_DEFAULT_COMMAND='fd -i -I -L --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# lua
export LUA_PATH="./?.lua;./?/init.lua;/usr/local/luarocks/share/lua/5.1/?.lua;/usr/local/luarocks/share/lua/5.1/?/init.lua"
export LUA_CPATH='./?.so;/usr/local/luarocks/share/lua/5.1/?.so'

# neovim
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
alias vim='nvim'
alias docs='cd ~/Documents/vim-workspace/docs && $EDITOR'

# }}}
# Alias {{{1
# open
alias awk='gawk'
alias sed='gsed'
alias r='open -R'
alias e='open -e'
#alias o='openfile'
alias o='open'
alias o.serverlist='open ~/Documents/zkzy/Implementation-doc/中科智云内部环境说明/虚拟机和宿主机分布情况说明.xlsx'
alias o.dblist='open ~/Documents/zkzy/Implementation-doc/中科智云内部环境说明/database_info.xlsx'
alias drawio='open -a draw.io.app'

alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'

alias z='_zlua -I'
alias pwgen='pwgen -r0oOiIlL'
alias grep='grep --color'
#alias tr='tmux -u attach'
alias s='sshrc'
alias ssh-with-password='ssh -F /dev/null -o "PreferredAuthentications=keyboard-interactive,password"'
alias mysql='mysql --default-auth=mysql_native_password'
alias mysql8='command mysql'
alias mysqldump='mysqldump --column-statistics=0'
alias mysqldump8='command mysqldump'
alias tl='python3 ~/code/translator/translator.py'
alias ldd='otool -L'
alias secp='copy_remote_screen_message_content_to_local_clipboard'
alias sqlplus='rlwrap sqlplus'

# }}}
# Functions {{{1
copy_remote_screen_exchange_content_to_local_clipboard(){ # {{{2
    ssh $1 cat /tmp/screen-exchange | pbcopy
}
# }}}
# }}}
vs(){ # {{{2
    mvim -n \
        -c "let w:remote_host=\"$1\"" \
        -c "let &titlestring=w:remote_host" \
        -c "Edit /root/" \
        -c "new" -c "ServerUpdateInfo"
    sshrc $1
}
# }}}
vpn.route.add.zkzy() { # {{{2
    sudo route -n add 192.168.80/24 -interface ppp0
}
# }}}
vpn.route.del.zkzy() { # {{{2
    sudo route -n delete 192.168.80/24 -interface ppp0
}
# }}}
safari.agent.ipad() { # {{{2
    defaults write com.apple.Safari CustomUserAgent "'Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3'"
}
# }}}
safari.agent.default() { # {{{2
    defaults delete com.apple.Safari CustomUserAgent
}
# }}}
proxy.ss.active(){ # {{{2
    export http_proxy="http://127.0.0.1:1087"
    export https_proxy="http://127.0.0.1:1087"
}
# }}}
proxy.ss.deactive(){ # {{{2
    export http_proxy=""
    export https_proxy=""
}
# }}}
oracle.env.gb2312(){ # {{{2
	echo export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
}
# }}}
color.print(){    #{{{2
    for C in {40..47}; do
        echo -en "\e[${C}m$C "
    done

    # high intensity colors
    for C in {100..107}; do
        echo -en "\e[${C}m$C "
    done

    # 256 colors https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit
    for C in {16..255}; do
        echo -en "\e[48;5;${C}m$C "
    done

    echo -e "\e(B\e[m"
}
#}}}
color.print.tput(){ #{{{2
    for C in {0..255}; do
        tput setab $C
        echo -n "$C "
    done
    tput sgr0
}
alias telnet='nc -vz -w 1'
#}}}
ssh.execute_local_script() { # {{{2
    if [[ $1 == "" ]]; then
        echo "$0 host script"
        return 1
    fi
    h=$1
    s=$2
    cat $2 | ssh -T $1
}
# }}}
n(){ # {{{2
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
# }}}
# }}}
# vim: fdm=marker sw=4 ts=4 et ft=zsh
