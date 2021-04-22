local Range = require("wr.Range")
local Cursor = require("wr.Cursor")
local utils = require("wr.utils")

WrappedRange = { }

function WrappedRange:new(
		left, -- Range
		inner,  -- Range
		right)  -- Range

	local o = {}

	o.left = left
	o.inner = inner
	o.right = right

	setmetatable(o, self)
	self.__index = self
	return o
end

function WrappedRange:newFromVisual()
	return WrappedRange:new( nil, Range:newFromVisual(), nil)
end

function WrappedRange:newFromCursor()
	local c = Cursor:newFromVim(vim.api.nvim_win_get_cursor(0))

	return WrappedRange:new(nil, Range:newFromCursor(c), nil)
end

function WrappedRange:newFromSep(left_sep, right_sep, one_line)
	local c = Cursor:newFromVim(vim.api.nvim_win_get_cursor(0))
	local left = Range:newFromFind(c, left_sep, false, true)
	local right = Range:newFromFind(c, right_sep, true, true)

	-- not find in current line
	if not left_sep or not right_sep  then
		return nil
	end

	if not one_line and not right.start.col then
		for i = c.line + 1, vim.api.nvim_buf_line_count(0) do
			right = Range:newFromFind(Cursor:new({i, nil}), right_sep, true, true)
			if right.start.col then
				break
			end
		end
	end

	if not one_line and not left.start.col then
		for i = c.line - 1, 1, -1 do
			left = Range:newFromFind(Cursor:new({i, nil}), left_sep, false, true)
			if left.start.col then
				break
			end
		end
	end

	-- not find in current document
	if not left.start.col or not right.start.col then
		return nil
	end

	local inner = Range:new(Cursor:new({left.stop.line, left.stop.col + 1}),
							Cursor:new({right.start.line, right.start.col - 1}))

	if inner.stop.col == 0 then
		local pl = vim.api.nvim_buf_get_lines(0, right.start.line - 2, right.start.line - 1, false)[1]

		inner.stop = Cursor:new({right.start.line - 1,  pl:len() + 1})
	end

	return WrappedRange:new(left, inner, right)
end

function WrappedRange:get_all()
	local start, stop

	if self.left and self.right then
		start = self.left.start
		stop = self.right.stop
	else
		start = self.inner.start
		stop = self.inner.stop
	end

	local lines = vim.api.nvim_buf_get_lines(0,
	                                         start.line - 1,
											 stop.line,
											 false)

	if start.line == stop.line then
		lines[1] = lines[1]:sub(start.col, stop.col)
	else
		lines[1] = lines[1]:sub(start.col)
		lines[-1] = lines[-1]:sub(1, stop.col)
	end

	return lines

end

function WrappedRange:range_all()
	local start = self.left.start
	local stop = self.right.stop

	vim.fn.setpos("'<", {0, start.line, start.col, 0})
	vim.fn.setpos("'>", {0, stop.line, stop.col, 0})
end

function WrappedRange:select_all()
	self:range_all()
	vim.api.nvim_command('normal gv')
end

function WrappedRange:range_inner()
	vim.fn.setpos("'<", {0, self.inner.start.line, self.inner.start.col, 0})
	vim.fn.setpos("'>", {0, self.inner.stop.line, self.inner.stop.col, 0})
end

function WrappedRange:select_inner()
	self:range_inner()
	vim.api.nvim_command('normal gv')
end

function WrappedRange:add_sep(left_sep, right_sep)
    print(left_sep, right_sep)
	vim.api.nvim_win_set_cursor(0, self.inner.stop:toVim())
	vim.api.nvim_put({right_sep}, "c", true, true)

	vim.api.nvim_win_set_cursor(0, self.inner.start:toVim())
	vim.api.nvim_put({left_sep}, "c", false, true)
end

function WrappedRange:remove_sep()
	local line

	-- right
	line = vim.api.nvim_buf_get_lines(0,
									  self.right.start.line - 1,
									  self.right.start.line,
									  false)[1]
	line = line:sub(1, self.right.start.col - 1) .. line:sub(self.right.stop.col + 1)

	vim.api.nvim_buf_set_lines(0,
							   self.right.start.line - 1,
							   self.right.start.line,
							   false,
							   {line})

	-- left
	line = vim.api.nvim_buf_get_lines(0,
									  self.left.start.line - 1,
									  self.left.start.line,
									  false)[1]
	line = line:sub(1, self.left.start.col - 1) .. line:sub(self.left.stop.col + 1)

	vim.api.nvim_buf_set_lines(0,
							   self.left.start.line - 1,
							   self.left.start.line,
							   false,
							   {line})
end

return WrappedRange
