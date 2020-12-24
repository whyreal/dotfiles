local M = {}

local map_opts = {noremap = false, silent = true, expr = false}

M.autocmd = function(cmd) vim.cmd("autocmd " .. cmd) end

M.map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', map_opts, opts or {})
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

function M.print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

return M
