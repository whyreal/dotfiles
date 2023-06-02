function joshuto

	set OUTPUT_FILE "/tmp/joshuto-cwd-$fish_pid"
	command joshuto --output-file "$OUTPUT_FILE" $argv
    #echo $status
    #echo $OUTPUT_FILE
    #cat $OUTPUT_FILE

    switch $status
    case 0
        # regular exit
        # output contains current directory
    case 101
        set JOSHUTO_CWD (cat "$OUTPUT_FILE")
        cd "$JOSHUTO_CWD"
    case 102
        # output selected files
    case '*'
        echo "Exit code: $exit_code"
        ;;
    end
end

