#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

find /tmp -name 'md_preview_*.html' |xargs rm

output=/tmp/md_preview_$1.html

cat <<eof > $output
<link rel='stylesheet' href='/Users/real/code/markdown-css-themes/avenir-white.css'/>
<link rel="stylesheet" href="/Users/real/code/highlight.js/styles/tomorrow.css">
<script src="/Users/real/code/highlight.js/highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
eof

$DIR/md2html.rb $1 >> $output

cat <<eof >> $output
eof
open $output
