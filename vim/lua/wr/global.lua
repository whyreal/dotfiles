local M = {}

M.map_opts = {noremap = false, silent = true, expr = false}
M.autocmd = function(cmd) vim.cmd("autocmd " .. cmd) end

M.map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', M.map_opts, opts or {})
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
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
        -- "<Plug>(vsnip-expand-or-jump)"
        return false
    elseif M.check_back_space() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
    else
        vim.fn["completion#trigger_completion"]()
    end
    return true
end

M.new_command = function(s)
	vim.cmd('command! ' .. s)
end

M.toggle_home_zero = function()
    local char_postion, _ = vim.api.nvim_get_current_line():find("[^%s]")
	if char_postion == nil then return end
	char_postion = char_postion	- 1
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
                                    '--bind=alt-c:execute(cp_file2clipboard.sh {4})+abort',
                                    '--bind=alt-o:execute(eval open {4})+abort',
                                    '--bind=alt-r:execute(eval open -R {4})+abort',
                                    '--header-lines=0',
                                    '--info=inline'}}, false)
end

return M
