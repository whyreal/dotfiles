test: test_parser test_cursor test_range

test_parser:
	@nvim -n --headless --noplugin -c "luafile tests/wr/test_parser.lua"
	@echo

test_cursor:
	@nvim -n --headless --noplugin -c "luafile tests/wr/cursor_test.lua" tests/wr/cursor_test.txt
	@echo

test_range:
	@nvim -n --headless --noplugin -c "luafile tests/wr/range_test.lua" tests/wr/range_test.txt
	@echo
