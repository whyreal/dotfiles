local Cursor = require("wr.Cursor")
local rt = require "resty.template"
local utils= require("wr.utils")
local lpeg = require("lpeg")
local R = require("lamda")
local Line = require("wr.Line")


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

function Range:linesInsert(lines, lnr)
	--print(R.toString(lines))
	vim.api.nvim_buf_set_lines(0, lnr, lnr, false, lines)
end

local rejectEmpty = R.reject(
	function (i)
		return R.isEmpty(i)
	end)

function Range:mdCreateUnOrderedList()
    R.forEach(function (ln)
        local l = Line:new(ln)
        if not l:isBlank() then
            l:addMdUnOrderListPrefix()
        end
    end,
    R.range(self.start.line, self.stop.line + 1)
    )
end

function Range:mdCreateOrderedList()
    local o = 1

    R.forEach(function (ln)
        local l = Line:new(ln)
        if not l:isBlank() then
            l:addMdOrderListPrefix(o)
            o = o+1
        end
    end,
    R.range(self.start.line, self.stop.line + 1)
    )
end

function Range:mdDeleteList()
    R.forEach(function (ln)
        local l = Line:new(ln)
        l:removeMdListPrefix()
    end,
    R.range(self.start.line, self.stop.line + 1)
    )
end

function Range:mdCreateCodeBlock()
    local indent = Line:new(self.start.line):getIndent()

    Line:new(self.stop.line):append({indent .. "```"})
    Line:new(self.start.line):insert({indent .. "```"})
end

function Range:mdCreateCodeBlockFromeCodeLine()
    local indent = Line:new(self.start.line):getIndent()

    Line:new(self.stop.line):append({indent .. "```"})

    R.forEach(function (ln)
        local l = Line:new(ln)
        if l:isBlank() then l:delete() end

        l:removeBackQuote()
    end,
    R.reverse(R.range(self.start.line, self.stop.line + 1))
    )

    Line:new(self.start.line):insert({indent .. "```"})
end

function Range:mdCreateCodeBlockFromeTable()
    local indent = Line:new(self.start.line):getIndent()

    Line:new(self.stop.line):append({indent .. "```"})

    R.forEach(function (ln)
        local l = Line:new(ln)
        if l:isBlank() then l:delete() end

        l.txt = l.txt:split("|")[3] or ""
        l:removeBackQuote()
    end,
    R.reverse(R.range(self.start.line, self.stop.line + 1))
    )

    Line:new(self.start.line):insert({indent .. "```"})
end

function Range:tplSet()
    view = R.map(function (ln)
        return Line:new(ln).txt
    end,
    R.range(self.start.line, self.stop.line + 1))

end

function Range:tplRender()
    local lastLine = Line:new(self.stop.line)

    local dataL = R.map(function (ln)
        return Line:new(ln).txt
    end,
    R.range(self.start.line, self.stop.line + 1))

    R.map(function (data)
        local result = string.split(rt.process(
            R.join("\n", view), {d = data:split("%s+", nil, true)}),
        "\n")

        lastLine:append(result)
        lastLine:append({""})

        end, R.reverse(dataL))
    lastLine:append({"---------RENDERED---------"})
end

function Range:sendVisualToTmux()
    R.forEach( function (ln)
        Line:new(ln):sendToTmux()
    end,
    R.range(self.start.line, self.stop.line + 1)
    )
end

function Range:filterMdHeader()
    return R.filter(function (l)
            return l:isHeader()
        end,
        R.map(function (lineNr)
                return Line:new(lineNr)
            end,
            R.reverse(R.range(self.start.line, self.stop.line + 1))
    ))
end

function Range:headerLevelUp()
    R.map(function (l)
            l:headerLevelUp()
        end,
        self:filterMdHeader()
    )
end

function Range:headerLevelDown()
    R.map(function (l)
            l:headerLevelDown()
        end,
        self:filterMdHeader()
    )
end

return Range
