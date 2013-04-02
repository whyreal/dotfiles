#!/bin/bash

#
# This script converts markdown into html, to be used with vimwiki's
# "customwiki2html" option. Experiment with the two proposed methods by
# commenting / uncommenting the relevant lines below.
#
# To use this script, you must have the Discount converter installed.
#
# http://www.pell.portland.or.us/~orc/Code/discount/
#
# To verify your installation, check that the commands markdown and mkd2text,
# are on your path.
#
# Also verify that this file is executable.
#
# Then, in your .vimrc file, set:
#
# g:vimwiki_customwiki2html=$HOME.'/.vim/autoload/vimwiki/customwiki2html.sh'
#
# On your next restart, Vimwiki will run this script instead of using the
# internal wiki2html converter.
#

# 1 markdown wiki /Users/real/Dropbox/localwiki/wiki_html/
# /Users/real/Dropbox/localwiki/wiki/index.wiki
# /Users/real/Dropbox/localwiki/wiki_html/style.css
FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"

MARKDOWN=/usr/bin/github-markup

FORCEFLAG=

OUTPUT=$OUTPUTDIR/$(basename "$INPUT").html
echo $INPUT $(basename $INPUT) $OUTPUT >> ~/aaaa

$MARKDOWN $INPUT > $OUTPUT

