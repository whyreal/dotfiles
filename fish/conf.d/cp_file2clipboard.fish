#https://apple.stackexchange.com/questions/15318/how-to-use-terminal-to-copy-a-file-to-the-clipboard/15484#15484

function cp2clipboard

osascript \
	-e 'on run args' \
	-e 'set the clipboard to POSIX file (first item of args)' \
	-e end \
	`realpath "$argv[1]"`

end