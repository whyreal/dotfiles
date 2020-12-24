
local Separator = {}
function Separator:new(str, cursor, after, smart)
 	local o = {}

	o.after = after
	o.smart = smart

	o.line = ""

    o.str = str
	o.left = 0
	o.right = 0

    o.cursor = cursor

	setmetatable(o, self)
	self.__index = self
	return o
end

function Separator:update_line()
	self.line = vim.api.nvim_buf_get_lines(0, self.cursor[1] - 1, self.cursor[1], true)[1]
end

function Separator:add()
	self:update_line()
	local index

	if not self.smart then
		vim.api.nvim_win_set_cursor(0, self.cursor)
	elseif self.after then
		index, _ = self.line:find_right("[^%s][%s%.,]", self.cursor[2], false)

		if index ~= nil then
			vim.api.nvim_win_set_cursor(0, {self.cursor[1], index - 1})
		else
			vim.api.nvim_win_set_cursor(0, {self.cursor[1], self.line:len()})
		end
	else
		_, index = self.line:find_left("[^%s]%s", self.cursor[2], false)
		if index ~= nil then
			vim.api.nvim_win_set_cursor(0, {self.cursor[1], index - 1})
		else
			vim.api.nvim_win_set_cursor(0, {self.cursor[1], 0})
		end
	end

	vim.api.nvim_put({self.str}, "c", self.after, true)

end

function Separator:should_move_cursor()
	if self.after or vim.api.nvim_win_get_cursor(0)[1] ~= self.cursor[1] then
		return false
	end
	return true
end

function Separator:remove()
	self:update_line()

	self.line = self.line:sub(1, self.left - 1) .. self.line:sub(self.right + 1)
	vim.api.nvim_buf_set_lines(0, self.cursor[1] - 1, self.cursor[1], false, {self.line})

	if self:should_move_cursor() then
		vim.api.nvim_win_set_cursor(0, {self.cursor[1], self.cursor[2] - self.str:len()})
	end
end

function Separator:exist()
	self:update_line()
	if self.after then
		self.left, self.right = self.line:find_right(self.str, self.cursor[2] + 1, true)
	else
		self.left, self.right = self.line:find_left(self.str, self.cursor[2], true)
	end

	if self.left == nil then
	    return false
	end

	return true
end

local TextRange = {}
imap.TextRange = TextRange

function TextRange:new(left_sep, right_sep, visual)
	local o = {}

	local startc, endc, cursor, startline, col
	local smart = true
	local after = nil

	if visual then
		startc = vim.api.nvim_buf_get_mark(0, '<')
		endc = vim.api.nvim_buf_get_mark(0, '>')
		smart = false
	else
		cursor = vim.api.nvim_win_get_cursor(0)
		startc = cursor
		endc = cursor
	end

    o.left_sep = Separator:new(left_sep, startc, false, smart)
    o.right_sep = Separator:new(right_sep, endc, true, smart)
	setmetatable(o, self)
	self.__index = self
	return o
end

function TextRange:toggle_word_wrap()
	if self.left_sep:exist() and self.right_sep:exist() then
		self.right_sep:remove()
		self.left_sep:remove()
		return
	end
	self.right_sep:add()
	self.left_sep:add()
end

function TextRange:select_all()
	if self.left_sep:exist() and self.right_sep:exist() then
		vim.fn.setpos("'<", {0, self.left_sep.cursor[1], self.left_sep.left, 0})
		vim.fn.setpos("'>", {0, self.right_sep.cursor[1], self.right_sep.right, 0})
	end
	vim.api.nvim_command('normal gv')
end

function TextRange:select_inner()
	if self.left_sep:exist() and self.right_sep:exist() then
		vim.fn.setpos("'<", {0, self.left_sep.cursor[1], self.left_sep.right + 1, 0})
		vim.fn.setpos("'>", {0, self.right_sep.cursor[1], self.right_sep.left - 1, 0})
	end
	vim.api.nvim_command('normal gv')
end

function TextRange:make_list()
	local lines = vim.api.nvim_buf_get_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false)
	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, "- " .. line)
		end
	end
	vim.api.nvim_buf_set_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false, tmplist)
end

function TextRange:remove_list()
	local lines = vim.api.nvim_buf_get_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false)
	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line, _ = line:gsub("^- ", "", 1)
			table.insert(tmplist, line)
		end
	end
	vim.api.nvim_buf_set_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false, tmplist)
end

function TextRange:make_ordered_list()
	local lines = vim.api.nvim_buf_get_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false)
	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line = line:gsub("^%s+", "", 1)
			table.insert(tmplist, #tmplist + 1 .. ". " .. line)
		end
	end
	vim.api.nvim_buf_set_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false, tmplist)
end

function TextRange:remove_ordered_list()
	local lines = vim.api.nvim_buf_get_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false)
	local tmplist = {}
	for index, line in ipairs(lines) do
		if line ~= "" then
			line, _ = line:gsub("^%d+%. ", "", 1)
			table.insert(tmplist, line)
		end
	end
	vim.api.nvim_buf_set_lines(0, self.left_sep.cursor[1] - 1, self.right_sep.cursor[1], false, tmplist)
end