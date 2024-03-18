#!/usr/bin/env node

import {exec} from 'node:child_process'

const output = exec("bin/kibana -c config/kibana-5gpm-5602.yml", {
    cwd: "/Users/Real/Applications/kibana-7.7.0-darwin-x86_64/",
    shell: "/usr/local/bin/fish"
})
