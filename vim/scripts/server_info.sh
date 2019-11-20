id mysql > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "================ MYSQL ==================={{{1"
    ps aux | grep mysql | grep -v grep
    echo "1}}}"
fi

id oracle > /dev/null 2>&1 && \
    echo "================ ORACLE ==================={{{1" && \
    su - oracle -lc "/home/oracle/app/oracle/product/11.2.0/dbhome_1/bin/lsnrctl status" && \
echo "1}}}"
echo ""

echo "================ top ==================={{{1"
top -b -n1 -c -w 512 -o COMMAND | awk '
    $12 !~ /^\[/ && !/sshrc/ && !/systemd/ && $2 !~ /oracle/ {
        print
    }'
echo "1}}}"
echo ""

echo "================ 磁盘 ==================={{{1"
df -h | awk '
    $5 > 85 && !/Filesystem/ {
        print $1 " 满了"
        print "--------------------"
    }
'
df -h
echo "1}}}"
echo ""

echo "================ 端口 ==================={{{1"
netstat -ntpl | sort -k2 -t ":" -h
echo "1}}}"
echo ""
