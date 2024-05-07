#!/usr/local/bin/fish

cd ~/Documents/DocBase/

find ~/Downloads/ -depth 1 -name '*.md' -exec mv {} ./0.未归档/ \;
