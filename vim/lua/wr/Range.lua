local Cursor = require("wr.Cursor")
local rt = require "resty.template"


local Range = { }

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

	return Range:new(Cursor:new({left.stop.line, left.stop.col}),
                     Cursor:new({right.start.line, right.start.col}))
end

function Range:make_list()
	local lines = self:get_lines()

	local tmplist = {}

	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, "- " .. line)
		end
	end

	self:set_lines(tmplist)
end

function Range:make_ordered_list()
	local lines = self:get_lines()

	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, #tmplist + 1 .. ". " .. line)
		end
	end

	self:set_lines(tmplist)
end

function Range:get_lines()
	return vim.api.nvim_buf_get_lines(0,
									 self.start.line - 1,
									 self.stop.line,
									 false)
end

function Range:set_lines(lines)
	vim.api.nvim_buf_set_lines(0,
	                           self.start.line - 1,
							   self.stop.line,
							   false,
							   lines)
end

function Range:insert_lines(lines, lnr)
	vim.api.nvim_buf_set_lines(0, lnr, lnr, false, lines)
end

function Range:remove_list()
	local lines = self:get_lines()

	local tmplist = {}

	for index, line in ipairs(lines) do
		if line ~= "" then
			line, _ = line:gsub("^- ", "", 1)
			-- ordered
			line, _ = line:gsub("^%d+%. ", "", 1)
			table.insert(tmplist, line)
		end
	end

	self:set_lines(tmplist)
end

local view = {}

function Range:set_tmpl()
	view = self:get_lines()
end

function Range:render_tmpl()
	local output
	local data = self:get_lines()
	local insert_lnr = self.stop.line
	local vlen = #view

	self:insert_lines({"---------RENDERED---------"}, insert_lnr)
	insert_lnr = insert_lnr + 1

    for _, datai in ipairs(data) do

        output = string.split(
					rt.process(
							table.concat(view, "\n"),
							{d = datai:split("%s+", nil, true)}),
					"\n")
		table.insert(output, "")

		self:insert_lines( output, insert_lnr)
		insert_lnr = insert_lnr + #output
    end
end

return Range
