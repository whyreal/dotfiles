local Cursor = require("wr.Cursor")

Range = { }

function Range:new(start, stop)
	local o = {}

	o.start = start
	o.stop = stop

	setmetatable(o, self)
	self.__index = self
	return o
end

function Range:newFromFind(cursor, str, after, plain)

	local txt = vim.api.nvim_buf_get_lines(0, cursor.line - 1, cursor.line, false)[1]
	local tlen = txt:len()
	local l, r

	if after then
		if cursor.col == nil then
			cursor.col = 0
		end

		l, r = txt:find_right(str, cursor.col, plain)
	else
		if cursor.col == nil then
			cursor.col = tlen
		end
		l, r = txt:find_left(str, cursor.col, plain)
	end

	local start = Cursor:new({cursor.line, l})
	local stop = Cursor:new({cursor.line, r})

	return Range:new(start, stop)
end

function Range:newFromVisual()
	return Range:new(
		Cursor:new(vim.api.nvim_buf_get_mark(0, '<')):fromVim(),
		Cursor:new(vim.api.nvim_buf_get_mark(0, '>')):fromVim())
end

function Range:newFromCursor(cursor)
	local txt = vim.api.nvim_buf_get_lines(0, cursor.line - 1, cursor.line, false)[1]
	local tlen = txt:len()

	local left = Range:newFromFind(cursor, "%S%s",false, false)
	if not left.start.col then
		left.start.col = 1
		left.stop.col = 1
	end

	local right = Range:newFromFind(cursor, "%S%s", true, false)
	if not right.start.col then
		right.start.col = tlen
		right.stop.col = tlen
	end

	local inner = Range:new(Cursor:new({left.stop.line, left.stop.col}),
							Cursor:new({right.start.line, right.start.col}))
	return inner
end

function Range:make_list()
	local lines = vim.api.nvim_buf_get_lines(0,
	                                         self.start.line - 1,
											 self.stop.line,
											 false)
	local tmplist = {}

	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, "- " .. line)
		end
	end

	vim.api.nvim_buf_set_lines(0,
	                           self.start.line - 1,
							   self.stop.line,
							   false,
							   tmplist)
end

function Range:make_ordered_list()
	local lines = vim.api.nvim_buf_get_lines(0,
	                                         self.start.line - 1,
											 self.stop.line,
											 false)
	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, #tmplist + 1 .. ". " .. line)
		end
	end

	vim.api.nvim_buf_set_lines(0,
	                           self.start.line - 1,
							   self.stop.line,
							   false,
							   tmplist)
end

function Range:remove_list()
	local lines = vim.api.nvim_buf_get_lines(0,
	                                         self.start.line - 1,
											 self.stop.line,
											 false)
	local tmplist = {}

	for index, line in ipairs(lines) do
		if line ~= "" then
			line, _ = line:gsub("^- ", "", 1)
			-- ordered
			line, _ = line:gsub("^%d+%. ", "", 1)
			table.insert(tmplist, line)
		end
	end

	vim.api.nvim_buf_set_lines(0,
	                           self.start.line - 1,
							   self.stop.line,
							   false,
							   tmplist)
end

return Range
