# use mycli
#alias mysql='mycli'
# alias mysql='mysql --default-auth=mysql_native_password'
# alias mysql8='command mysql'
alias mysqldump='mysqldump --column-statistics=0'
alias mysqldump8='command mysqldump'

alias mysqlsh.dis-ssl='mysqlsh --ssl-mode=disabled'
alias mysql.dis-ssl='mysqlsh --ssl-mode=disabled'

set -g fish_user_paths "/usr/local/opt/mysql-client/bin"  $fish_user_paths
