#!/bin/zsh
#
antigen () {
        local MATCH MBEGIN MEND
        [[ "$ZSH_EVAL_CONTEXT" =~ "toplevel:*" || "$ZSH_EVAL_CONTEXT" =~ "cmdarg:*" ]] && source "/usr/local/Cellar/antigen/2.2.3/share/antigen/antigen.zsh" && eval antigen $@
        return 0
}

# zsh resource manager
echo "-------- update antigen--------"
antigen update

echo "-------- update tmux--------"
/Users/Real/.tmux/plugins/tpm/bin/update_plugins all

#echo "-------- update homebrew--------"
#brew upgrade
#brew cleanup