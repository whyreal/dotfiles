local Cursor = { }

function Cursor:new(cursor)
	local o = {}

	o.line = cursor[1]
	o.col = cursor[2]

	setmetatable(o, self)
	self.__index = self
	return o
end

function Cursor:moveToLineBegin()
	self.col = 1
end

function Cursor:moveToLineEnd()
	local txt = vim.api.nvim_buf_get_lines(0, self.line - 1, self.line, false)[1]
	self.col = txt:len()
end

function Cursor:fromVim()
	self.col = self.col + 1
	return self
end

function Cursor:toVim()
	return {self.line, self.col - 1}
end

return Cursor
