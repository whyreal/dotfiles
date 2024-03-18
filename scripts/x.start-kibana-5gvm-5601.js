#!/usr/bin/env node

import {execSync} from 'node:child_process'

execSync("bin/kibana -c config/kibana-5gvm-5601.yml", {
    cwd: "~/Applications/kibana-7.7.0-darwin-x86_64/"
})
