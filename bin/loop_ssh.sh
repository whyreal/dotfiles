#!/bin/bash

if [[ -f $1 ]];then
    while read ip; do
        if [[ ! `echo "$ip"|grep "^#"` ]];then
            echo "==========""$ip""=========="
            cat $2 |ssh -T root@"$ip"
        fi
    done < $1
else
    cat $2 | ssh -T root@$1
fi
