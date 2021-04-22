local utils = require("wr.utils")
local R = require("lamda")

local function add_prefix(p, s)
	return s and p .. s or ""
end

M = {}

function M.help(link)
	vim.cmd(("help %s"):format(link.path))
end

function M.code(link)
	vim.fn.system(("code %q"):format(link.path))
end

function M.vimr(link)
	vim.fn.system(("cd %q && vimr"):format(link.path))
end

function M.vim(link)
	vim.fn.system(('term.scpt "cd %q && vim"'):format(link.path))
end

function M.http(link)

    local _cmd = ("open -a '" .. DefaultBrowser .. "' '%s://%s"):format(link.schema, link.domain)
	            .. add_prefix(":", link.port)
				.. add_prefix("", link.path)
	            .. add_prefix("?", link.query)
	            .. add_prefix("#", link.fragment) .. "'"

    vim.fn.system(_cmd)
end
M.https = M.http

function M.joplin(link)
	utils.edit_joplin_note(link.path)
	if link.fragment then M.gotoFragment(link) end
end

function M.scp(link)
	vim.cmd(("tabedit %s://%s/%s"):format(link.schema, link.domain, link.path))
	if link.fragment then M.gotoFragment(link) end
end

function M.system(link)
	local _cmd
	local app = ""
	if R.endsWith("drawio.png", link.path) then
		app = "-a draw.io.app"
	end

	_cmd = ("open %s %q"):format(app, link.path)
	return vim.fn.system(_cmd)
end

function M.text(link)
	vim.cmd(("edit %s"):format(link.path))
	if link.fragment then M.gotoFragment(link) end
end

function M.directory(link)
	M.system(link)
end

function M.gotoFragment(link)
    local _, lnr = link:find_fragment(1, true, true)
	if not lnr then return end

	vim.api.nvim_win_set_cursor(0, {lnr, 0})

	vim.cmd("normal! zO")
	vim.cmd("normal! zt")
end

return M
