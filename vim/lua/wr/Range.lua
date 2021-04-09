local Cursor = require("wr.Cursor")
local rt = require "resty.template"
local utils= require("wr.utils")
local lpeg = require("lpeg")
local R = require("lamda")


local Range = { }

local patterns = {}
patterns.indent_line = lpeg.Cg(lpeg.space^0) * lpeg.Cg(lpeg.P(1)^0)
patterns.block_line = (lpeg.S("`-|") + lpeg.R("09") + lpeg.space )^0

local view = {}

function Range:new(
		start, -- Cursor
		stop   -- Cursor
	)
	local o = {}

	o.start = start
	o.stop = stop

	setmetatable(o, self)
	self.__index = self
	return o
end

function Range:newFromFind(
		cursor, -- Cursor
		str, after, plain
	)
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
		Cursor:newFromVim(vim.api.nvim_buf_get_mark(0, '<')),
		Cursor:newFromVim(vim.api.nvim_buf_get_mark(0, '>')))
end

function Range:newFromCurrentLine()
	local c = Cursor:newFromVim(vim.api.nvim_win_get_cursor(0))
	return Range:new(c:moveToLineBegin(), c:moveToLineEnd())
end

-- current word
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

function Range:linesGet()
	return vim.api.nvim_buf_get_lines(0,
									 self.start.line - 1,
									 self.stop.line,
									 false)
end

function Range:linesSet(lines)
	vim.api.nvim_buf_set_lines(0,
	                           self.start.line - 1,
							   self.stop.line,
							   false,
							   lines)
end

function Range:linesInsert(lines, lnr)
	--print(R.toString(lines))
	vim.api.nvim_buf_set_lines(0, lnr, lnr, false, lines)
end

function Range:lineModify(listPrefix)

	assert(R.isFunction(listPrefix), "listPrefix should be a function!")

	return R.reject(
	function (i)
		return R.isEmpty(i)
	end,
	R.mapAccum(function (acc, l)
			local indent, ltxt = lpeg.match(patterns.indent_line, l)
			if R.isEmpty(ltxt) then return {acc, ""} end
			return {acc + 1, indent .. listPrefix(acc, ltxt)}
		end,
		1,
		self:linesGet())[2])
end

local rejectEmpty = R.reject(
	function (i)
		return R.isEmpty(i)
	end)

function Range:mdCreateUnOrderedList()
	self:linesSet(self:lineModify(function (acc, ltxt)
		return "- " .. ltxt
	end))
end

function Range:mdCreateOrderedList()
	self:linesSet(self:lineModify(function (acc, ltxt)
		return acc .. ". " .. ltxt
	end))
end

function Range:mdDeleteList()
	self:linesSet(self:lineModify(function (acc, ltxt)
		-- unordered
		ltxt, _ = ltxt:gsub("^- ", "", 1)
		-- ordered
		ltxt, _ = ltxt:gsub("^%d+%. ", "", 1)
		return ltxt
	end))
end

function Range:mdCreateCodeBlock(lines)
	if not lines then
		lines = self:linesGet()
	end
	local indent, _ = lpeg.match(patterns.indent_line, R.head(lines))

	table.insert(lines, 1, indent .. "```")
	table.insert(lines, indent .. "```")
	self:linesSet(lines)
end

function Range:mdCreateCodeBlockFromeCodeLine()
	self:mdCreateCodeBlock(R.map(function (line)
			return line:strip():gsub("[`]", "")
		end, R.reject(function (line)
			return lpeg.match(patterns.block_line, line) == #line + 1
		end, self:linesGet())))
end

function Range:mdCreateCodeBlockFromeTable()
	self:mdCreateCodeBlock(R.map(function (line)
			return (line:split("|")[3] or ""):strip():gsub("[`]", "")
		end, R.reject(function (line)
			return lpeg.match(patterns.block_line, line) == #line + 1
		end, self:linesGet())))
end

function Range:tplSet()
	view = self:linesGet()
end

function Range:tplRender()

	self:linesInsert(
		R.reduce(
			R.concat,
			{"---------RENDERED---------"},
			R.map(function (data)
				return R.append("", string.split(
							rt.process(
									R.join("\n", view),
									{d = data:split("%s+", nil, true)}),
							"\n"))
			end, self:linesGet())),
		self.stop.line)
end

local function sendTextToTmux(text)
	text = R.trim(text)
	text = R.replace('"', '\\"', 0, text)
	vim.fn.system('tmux send-keys "' .. text .. '" ENTER')
end

function Range:sendTextToTmux()
	local line = self:linesGet()[1]
	sendTextToTmux(line)
end

function Range:sendVisualToTmux()
	for _, line in ipairs(self:linesGet()) do
		sendTextToTmux(line)
	end
end

return Range
