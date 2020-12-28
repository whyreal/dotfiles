local WrappedRange = require("wr.WrappedRange")
local mimetypes = require("mimetypes")
local lfs = require("lfs")
local utils = require("wr.utils")

local Link = {}

local function extension (filename)
    return filename:match(".+%.([%a%d]+)$")
end

function Link:new()
    local tr = WrappedRange:newFromSep("[", ")", false) or
               WrappedRange:newFromCursor()

    local s = tr:get_all()[1]
    local o = utils.parse_link(s)
	--require("wr.utils").print_r(o)
	assert(type(o) == "table", "Can't parse link!!!")
    setmetatable(o, self)
    self.__index = self

	if o.schema == "file" then
	    local a = lfs.symlinkattributes(o.path)
		if a then
			o.schema = a.mode
		end
	end

	if o.schema == "file" then
		local t = mimetypes.guess(o.path, require("wr.mimedb"))
		if t and t:startswith("text") then
			o.schema = "text"
		else
			o.schema = "system"
		end
	end

    return o
end

function Link:handler_http()

	local function add_prefix(p, s)
		return s and p .. s or ""
	end

    local _cmd = ("open -a Firefox.app '%s://%s"):format(self.schema, self.domain)
				.. add_prefix("", self.path)
	            .. add_prefix(":", self.port)
	            .. add_prefix("?", self.query)
	            .. add_prefix("#", self.fragment) .. "'"

    vim.fn.system(_cmd)
end

function Link:handler_scp()
    vim.cmd(("edit %s://%s"):format(self.schema, self.path))
    if self.fragment then self:gotoFragment() end
end

function Link:handler_system()
	local _cmd = "open " .. self.path
	return vim.fn.system(_cmd)
end

function Link:handler_text()
	vim.cmd(("edit %s"):format(self.path))
	if self.fragment then self:gotoFragment() end
end

function Link:handler_directory()
	self:handler_system()
end

Link.handler_https = Link.handler_http
Link.handler_fragment = Link.gotoFragment

local function get_workspace_links()
	local ws = vim.fn.getcwd()
    local attribute

	local links = {}
	links["."] = ws
	links["~"] = vim.fn.getenv("HOME")

	for name in lfs.dir(ws) do
		attribute = lfs.symlinkattributes(ws .. "/" .. name)
		if attribute.mode == "link" then links[name] = attribute.target end
	end

	return links
end

local function get_path_in_ws(path)
	local relapath, tlen
	local maxTarget = 0

	for name, target in pairs(get_workspace_links()) do
		target, _ = target:gsub("/*$", "")
		if path:startswith(target) then
			tlen = target:len()
			if tlen > maxTarget then
				maxTarget = tlen
				relapath = name .. path:sub(tlen + 1)
			end
		end
	end

	return relapath
end

function Link:copyFragLinkW(with_frag)
	local path = vim.fn.expand("%:p")
	local relapath = get_path_in_ws(path) or path

	local fragment

	if with_frag then
		local c = vim.api.nvim_win_get_cursor(0)
		fragment = self:find_fragment(c[1], false)
	end

	if with_frag and fragment then
		return vim.fn.setreg("+",
			("[%s](%s#%s)"):format(fragment, relapath, fragment))
	else
		local basename = path:gsub(".*/", ""):gsub("%..*", "")
		return vim.fn.setreg("+",
			("[%s](%s)"):format(basename, relapath))
	end
end

function Link:copyFragLinkB()
	local c = vim.api.nvim_win_get_cursor(0)
	local fragment = self:find_fragment(c[1], false)

	if not fragment then return nil end

    return vim.fn.setreg("+", ("[%s](#%s)"):format(fragment, fragment))
end

function Link:find_fragment(start, after, compare_s)
    local fragment, lnr

    for i = start
		    or (after and 1 or vim.api.nvim_buf_line_count(0)),
		after and vim.api.nvim_buf_line_count(0) or 1,
		after and 1 or -1
	do
		fragment = utils.parse_title(vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1])
		if fragment then
			fragment = fragment:gsub("%s", "_")
			lnr = i
			if (not compare_s)
				or (compare_s and self.fragment == fragment)
			then
				break
			end
		end
    end
	return fragment, lnr
end

function Link:gotoFragment()
    local _, lnr = self:find_fragment(1, true, true)
	if not lnr then return end

	vim.api.nvim_win_set_cursor(0, {lnr, 0})

	vim.cmd("normal! zO")
	vim.cmd("normal! zt")
end

function Link:open()
	self["handler_" .. self.schema](self)
end

function Link:resolv()
    vim.fn.system("open -R " .. self.path)
end

return Link
