#!/bin/bash

genpac --format='pac' \
	--pac-proxy='SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080; DIRECT;' \
	--user-rule-from='~/.ShadowsocksX/user-rule.txt' \
	--gfwlist-proxy='SOCKS5 127.0.0.1:1080;' > ~/.ShadowsocksX/gfwlist.js
