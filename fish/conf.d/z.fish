set -x _ZO_FZF_OPTS "--bind=ctrl-z:ignore --exit-0 --height=40% --inline-info --no-sort --reverse --select-1"

zoxide init fish | source

function z
    if test -z $argv[1]
        __zoxide_zi
    else
        __zoxide_z $argv
    end
end
