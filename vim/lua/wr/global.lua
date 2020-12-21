local M = {}

M.map_opts = {noremap = false, silent = true, expr = false}
M.autocmd = function(cmd) vim.cmd("autocmd " .. cmd) end

M.map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', M.map_opts, opts or {})
	if opts.buffer == true then
		opts.buffer = nil
		vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
	end
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

M.map_norange_lua = function (mode, lhs, rhs, opts)
    M.map(mode, lhs, (":<C-U>lua %s<CR>"):format(rhs), opts)
end

M.maplua = function(mode, lhs, rhs, opts)
    M.map(mode, lhs, ("<cmd>lua %s<CR>"):format(rhs), opts)
end

M.mapcmd = function(mode, lhs, rhs, opts)
    M.map(mode, lhs, ("<cmd>%s<CR>"):format(rhs), opts)
end

M.check_back_space = function ()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

M.imap_cr = function ()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn["complete_info"]()["selected"] ~= -1 then
            vim.fn["completion#wrap_completion"]()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-e><CR>", true, false, true), 'n', true)
        end
    else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', true)
    end
    return ""
end

M.imap_tab = function ()
    if vim.fn.pumvisible() ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-n>", true, false, true), 'n', true)
    elseif vim.fn["vsnip#available"](1) ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sej", true, false, true), 't', true)
    elseif M.check_back_space() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
    else
        vim.fn["completion#trigger_completion"]()
    end
    return ""
end

M.smap_tab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sjn", true, false, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
    end
    return ""
end

M.imap_stab = function ()
    if vim.fn.pumvisible() ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, false, true), 'n', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-h>", true, false, true), 'n', true)
    end
end

M.smap_stab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sjp", true, false, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), 'n', true)
    end
end

M.new_cmd = function(name, cmd)
    vim.cmd(('command! %s %s'):format(name, cmd))
end

M.toggle_home_zero = function()
    local char_postion, _ = vim.api.nvim_get_current_line():find("[^%s]")
    if char_postion == nil then return end
    char_postion = char_postion    - 1
    local position = vim.api.nvim_win_get_cursor(0)
    if position[2] == char_postion then
        vim.api.nvim_win_set_cursor(0, {position[1], 0})
    else
        vim.api.nvim_win_set_cursor(0, {position[1], char_postion})
    end
end

function M.cd_workspace(path)
    vim.cmd("lcd " .. path)
    vim.cmd("Explore " .. path)
end

function M.add_blank_line_before()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1,0, {""})
end

function M.add_blank_line_after()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, current_line, current_line,0, {""})
end

function M.edit_remote_file(file)
    vim.command("set buftype=nofile")
    local remote_host = exists("w:remote_host")
    if remote_host then
        vim.command("e scp://" .. remote_host .. "/" .. file)
    end
end

local function insert_cmd_output(cmd)
    local b = vim.buffer()

    local output = io.popen(cmd)
    for line in output:lines() do
        b:insert(line)
    end
    btarget[1] = nil
end

function M.update_server_info()
    vim.command("set fdm=marker buftype=nofile")
    local script = "~/.vim/scripts/server_info.sh"

    local remote_host = exists("w:remote_host")
    if remote_host then
        local cmd = "cat " .. script .." | ssh -T " .. remote_host
        vim.window().line = 1
        vim.command("normal dG")
        insert_cmd_output(cmd)
        vim.window().line = 1
    end
end

function M.template_set(firstline, lastline)
    M.view = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    M.view = table.concat(M.view, "\n")
end

function M.template_render(firstline, lastline)
    local template = require "resty.template"
    local data_lines = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    for _, data in ipairs(data_lines) do
        local output = template.process(M.view, {d = string.split(data)})
        vim.api.nvim_buf_set_lines(0, lastline, lastline, false, string.split(output, "\n"))
    end
end

M.fzfwrap = {}
M.fzfwrap.files = function()
    vim.fn['fzf#vim#files']("", {options = {
                                    '--history=' .. vim.env.HOME .. '/.fzf.history',
                                    '--preview', 'cat {}',
                                    '--preview-window', 'right:50%:hidden',
                                    '--bind=alt-c:execute(cp_file2clipboard.sh {})+abort',
                                    '--bind=alt-o:execute(open {})+abort',
                                    '--bind=alt-r:execute(open -R {})+abort',
                                    '--bind=alt-p:toggle-preview',
                                    '--info=inline'}}, false)
end

M.fzfwrap.buffers = function()
    vim.fn['fzf#vim#buffers']("", {options = {
                                    '--history=' .. vim.env.HOME .. '/.fzf.history',
                                    '--bind=alt-c:execute(cp_file2clipboard.sh {4})+abort',
                                    '--bind=alt-o:execute(eval open {4})+abort',
                                    '--bind=alt-r:execute(eval open -R {4})+abort',
                                    '--header-lines=0',
                                    '--info=inline'}}, false)
end

M.fzfwrap.rg = function (arg)
	local cmd = 'rg -L --column --line-number --no-heading --color=always --smart-case -- ' .. arg
	vim.fn['fzf#vim#grep'](cmd, 1, vim.fn['fzf#vim#with_preview'](), 0)
end

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
M.TextRange = TextRange

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

return M
