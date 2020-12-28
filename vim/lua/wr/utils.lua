local lpeg = require("lpeg")
lpeg.locale(lpeg) 

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

M.parse_link = setfenv(function (s)
	local p = P{
		"LINK",
		LINK = V'md_link' + V'url',

		md_link = "[" * V'id'^-1 * "](" * V'url' * V'title'^-1 * ")",
		url = V'remote_path' + V'local_path' + V'fragment_path',

		remote_path = V'schema' * V'domain' * V'port'^-1 * V'path'^-1 * V'query'^-1 * V'fragment'^-1, 
		local_path = Cg(Cc("file"), "schema") * V'path' * V'fragment'^-1,
		fragment_path = Cg(Cc("fragment"), "schema") * V'fragment',

		id = Cg(V'c2'^1, "id"),
		schema = Cg(alnum^1, "schema") * "://",
		domain = Cg(V'c3'^1 * ("." * V'c3'^1)^1 , "domain") ,
		port = ":" * Cg(digit^1 , "port") ,
		path = Cg((V'path_sep'^0 * V'c'^1 + V'path_sep'^1 * V'c'^0)^1 , "path") ,
		query = "?" * Cg(V'c'^1 , "query") ,
		fragment = "#" * Cg(V'c'^1 , "fragment") ,
		title = space^1 * Cg(V'c2'^0 , "title") ,

		c = 1 - S("\t /()[]:?#"),
		c2 = 1 - S("])"),
		c3 = alnum + S("-_"),
		path_sep = S("~/."),
	}
	return match(Ct(p), s)
end , lpeg)

M.parse_title = setfenv(function(s)
	local p = P{
		"TITLE";
		TITLE = V'with_link' + V'without_link',

		with_link = V'header_sign' * "[" * V'title' * "]",
		without_link = V'header_sign' * V'title',

		title = C((1 - S("[]"))^1),
		header_sign = P"#"^1 * space^1,
	}
	return match(p, s)
end, lpeg)

function M.esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

return M
