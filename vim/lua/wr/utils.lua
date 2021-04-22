local lpeg = require("lpeg")
lpeg.locale(lpeg)
local P = lpeg.P
local V = lpeg.V
local S = lpeg.S
local Cmt = lpeg.Cmt
local Cg = lpeg.Cg
local Cc = lpeg.Cc
local alnum = lpeg.alnum
local digit = lpeg.digit
local space = lpeg.space
local Cb = lpeg.Cb
local Ct = lpeg.Ct
local C = lpeg.C
local match = lpeg.match

local htmlparser = require("htmlparser")
local htmlEntities = require("htmlEntities")
local R = require("lamda")

local HOME = vim.env.HOME
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

-- M.map_norange_lua = function (mode, lhs, rhs, opts)
--     M.map(mode, lhs, (":<C-U>lua %s<CR>"):format(rhs), opts)
-- end

-- M.maplua = function(mode, lhs, rhs, opts)
--     M.map(mode, lhs, ("<cmd>lua %s<CR>"):format(rhs), opts)
-- end

-- M.mapcmd = function(mode, lhs, rhs, opts)
--     M.map(mode, lhs, ("<cmd>%s<CR>"):format(rhs), opts)
-- end

M.check_back_space = function ()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

M.new_cmd = function(name, cmd)
    vim.cmd(('silent command! %s %s'):format(name, cmd))
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

--local function sub_print_r(t,indent)
    --if (print_r_cache[tostring(t)]) then
        --print(indent.."*"..tostring(t))
    --else
        --print_r_cache[tostring(t)]=true
        --if (type(t)=="table") then
            --for pos,val in pairs(t) do
                --if (type(val)=="table") then
                    --print(indent.."["..pos.."] => "..tostring(t).." {")
                    --sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                    --print(indent..string.rep(" ",string.len(pos)+6).."}")
                --elseif (type(val)=="string") then
                    --print(indent.."["..pos..'] => "'..val..'"')
                --else
                    --print(indent.."["..pos.."] => "..tostring(val))
                --end
            --end
        --else
            --print(indent..tostring(t))
        --end
    --end
--end

--function M.print_r ( t )
    --local print_r_cache={}
    --if (type(t)=="table") then
        --print(tostring(t).." {")
        --sub_print_r(t,"  ")
        --print("}")
    --else
        --sub_print_r(t,"  ")
    --end
    --print()
--end

M.parse_link = function (s)
	local p = P{
		"LINK",
		LINK = V'fragment_path' + V'joplin_path' + V'remote_path' + V'local_path',

		remote_path = Cg(alnum^1, "schema") * V'remote' * "://"
                    * V'domain' * V'port'^-1
					* V'path'^-1 * V'query'^-1 * V'fragment'^-1,
		joplin_path   = Cg(Cc("joplin"),   "schema") * ":/" * Cg(alnum^1, "path") * V'fragment'^-1,
		fragment_path = Cg(Cc("fragment"), "schema") * V'fragment',
		local_path    = Cg(alnum^1, "schema") * "://" * V'path' * V'fragment'^-1
                      + Cg(Cc("file"),   "schema") * V'path' * V'fragment'^-1,

        remote = Cmt(Cb("schema"), function (_, _, schema)
            return R.contains(schema, {"http", "https", "scp"})
        end),
		domain = Cg((alnum + S"-_.")^1 , "domain") ,
		port = ":" * Cg(digit^1 , "port") ,
		path = Cg(V'c'^1, "path"),
		query = "?" * Cg(V'c'^1 , "query") ,
		fragment = "#" * Cg(V'c'^1 , "fragment") ,

		c = 1 - S(":?#"),
	}
	return match(Ct(p), s)
end

M.parse_title = function(s, level)
	local header_sign
	if not level then
		header_sign = P"#"^1 * space^1
	else
		header_sign = P(("#"):rep(level)) * space^1
	end

	local p = P{
		"TITLE";
		TITLE = V'with_link' + V'without_link',

		with_link = P(1 - P"#")^0 * header_sign * "[" * V'title' * "]",
		without_link = P(1 - P"#")^0 * header_sign * V'title',

		title = C((1 - S("[]"))^1),
	}
	return match(p, s)
end

M.parse_path = function(path)
	local p = P{
		"PATH";
		PATH = V'dir' * V'filename',

		dir = Cg((P("/")^0 * V'c'^1 * P("/")^1)^0, "dir"),
		filename = Cg(V'c'^1, "filename"),
		c = P(1) - P"/"
	}
	return match(Ct(p), path)
end

function M.esc(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

M.parse_joplin_file_name = setfenv(function(s)
	local p = P{
		"ID";
		ID = "edit-" * C((1 - S"-.")^1) * ".md"
	}
	return match(p, s)
end, lpeg)

function M.edit_joplin_note(id)
	local script = vim.fn.expand("~/.config/nvim/scripts/joplin_handler.py")
	local joplin_config_dir = vim.fn.expand("~/.config/joplin-desktop/")

	if id:len() == 0 then
		local filename = vim.fn.expand("%:p:t")
		id = M.parse_joplin_file_name(filename)
	else
		vim.fn.system(script .. " edit " .. id)
		vim.cmd(("edit %s/edit-%s.md"):format(joplin_config_dir, id))
	end

	vim.cmd(("autocmd BufWritePost <buffer> exec '!%s update %s'"):format(script, id))
	vim.cmd(("autocmd BufWipeout <buffer> exec '!%s delete %s'"):format(script, id))

end

function M.markdown_unescape()
	vim.cmd[[%s/\\\([\[\]\.\-\*\~\!\#\_\=]\)/\1/g]]

	vim.cmd[[%s/  $//ge]]

	vim.cmd[[write]]
end

local content_path = {}

content_path["www.cnblogs.com"] = "#mainContent"

function M.markdown_download(url)
	local title, article, html, root, htmlf

	local domain = M.parse_link(url).domain
	local cookie = HOME .. "/Documents/Cookies/" .. domain .. ".txt"

	-- wget -k 和 -O - 无法共用，必须使用临时文件
    local html_path = os.tmpname ()
	-- 依赖 wget
	-- wget -k
	-- After the download is complete, convert the links in the document to make them suitable for local viewing.
    os.execute(("wget -k --no-check-certificate "
	            .. "--header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:84.0) Gecko/20100101 Firefox/84.0' "
	            .. "--load-cookies %s --save-cookies %s --keep-session-cookies "
				.. "%q -O %s -o /dev/null")
				:format(cookie, cookie, url, html_path))
	htmlf = io.open(html_path)
	html = htmlf:read("*a")
	htmlf:close()
	os.remove(html_path)

	root = htmlparser.parse(html, 10000)

	title = root("head > title")
	assert(type(title) == "table" )
	assert(#title >= 1)
	title = htmlEntities.decode(title[1]:getcontent())

	article = root(content_path[domain])
	article = #article ~= 0 and article or root("article")
	article = #article ~= 0 and article or root("#content")
	article = #article ~= 0 and article or root("body")
	print(#article)
	assert(type(article) == "table")
	assert(#article >= 1)
	-- data-original-src 等属性，用来实现延迟加载
	-- 这里需要将 data-original-src 转换成 src
	-- 使用gsub 是无奈的选择
	-- 		pandoc 会忽略 src 为空的 img，无法通过 filter 修改
	-- 		当前版本 htmlparser 只提供解析，无法正常修改 attr
	--article = htmlEntities.decode(article[1]:gettext())
	article = article[1]:gettext()
	article = article:gsub("data%-original%-", "")
	article = article:gsub("%/%/upload%-images", "https://upload%-images")

	local markdown = HOME .. "/Documents/WebClipping/" .. title:gsub("[%p%s]", "_") .. ".md"
    local f = io.popen(("pandoc --wrap=none -f html-native_divs-native_spans -t gfm+hard_line_breaks -o %q")
				:format(markdown), "w")
	f:write(title .. "\n\n")
	f:write(article)
	f:flush()
	f:close()

	vim.cmd("edit " .. markdown)
end

return M
