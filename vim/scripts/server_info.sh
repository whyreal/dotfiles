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
