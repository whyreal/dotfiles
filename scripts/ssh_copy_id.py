import pexpect
import sys
import json

config_file = 'targets.json'

def ssh_copy_id(host, passwd, key_path):
    print host,
    cmd = '/usr/bin/ssh-copy-id -i %s root@%s' % (key_path, host)
    child = pexpect.spawn(cmd)
    while True:
        index = child.expect_exact(['Number of key(s) added', 'password:', 'continue connecting (yes/no)', 'already exist', pexpect.EOF, pexpect.TIMEOUT])
        if index == 0:
            print "added"
        elif index == 1:
            child.sendline(passwd)
        elif index == 2:
            child.sendline('yes')
        elif index == 3:
            print "already exist"
        elif index == 4:
            break
        elif index == 5:
            print "timeout"
            break

def conf_init():
    with open(config_file, 'w') as f:
        f.write("""{
    "key_path": "/path/to/ssh publice key file",
    "user": "root",
    "hosts": {
        "ip1": "pw1",
        "{0}": "{1}",
        "{0}": "{1}"
    }
}""")

if sys.argv[1] == 'init':
    conf_init()
elif sys.argv[1] == 'go':
    with open(config_file) as f:
        config = json.load(f)
    for h, p in config['hosts'].iteritems():
        ssh_copy_id(h, p, config['key_path'])
