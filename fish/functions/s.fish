function s

    if test -z $argv[1]
        set -l host (command cat \
        (command awk '/^[ \t]*[Hh]ost/ && $2 != "*" {for (i = 2; i <= NF; i++) print $i}' ~/.ssh/config /etc/ssh/ssh_config | psub) \
        (command awk '/^[a-z1-9]/{print $1}' /etc/hosts ~/.ssh/known_hosts | psub) \
        | sort -u | fzf --reverse --history="$HOME/.fzf.history")

        if test -n "$host"
            ssh $host
        end
    else
        ssh $argv
    end
end
