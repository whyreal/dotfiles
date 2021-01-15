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

    local txt = tr:get_all()[1]
    local o = utils.parse_link(txt)
	--o.url = o[1]
	--utils.print_r(o)
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

	if o.path then
		o.path = vim.fn.expand(o.path)
	end

    return o
end

local function add_prefix(p, s)
	return s and p .. s or ""
end

function Link:gotoFragment()
    local _, lnr = self:find_fragment(1, true, true)
	if not lnr then return end

	vim.api.nvim_win_set_cursor(0, {lnr, 0})

	vim.cmd("normal! zO")
	vim.cmd("normal! zt")
end

Link.handlers = {}

function Link.handlers.help(self)
	vim.cmd(("help %s"):format(self.subject))
end

function Link.handlers.http(self)

    local _cmd = ("open -a Firefox.app '%s://%s"):format(self.schema, self.domain)
				.. add_prefix("", self.path)
	            .. add_prefix(":", self.port)
	            .. add_prefix("?", self.query)
	            .. add_prefix("#", self.fragment) .. "'"

    vim.fn.system(_cmd)
end
Link.handlers.https = Link.handlers.http

function Link.handlers.joplin(self)
	utils.edit_joplin_note(self.path)
	if self.fragment then self:gotoFragment() end
end

function Link.handlers.scp(self)
	vim.cmd(("tabedit %s://%s/%s"):format(self.schema, self.domain, self.path))
	if self.fragment then self:gotoFragment() end
end

function Link.handlers.system(self)
	local _cmd = ("open %q"):format(self.path)
	return vim.fn.system(_cmd)
end

function Link.handlers.text(self)
	vim.cmd(("tabedit %s"):format(self.path))
	if self.fragment then self:gotoFragment() end
end

function Link.handlers.directory(self)
	self.handlers.system(self)
end

Link.handlers.fragment = Link.gotoFragment

local function get_workspace_links()
	local ws = vim.fn.getcwd()
    local attribute, target

	local links = {}
	links["."] = ws
	links["~"] = vim.fn.getenv("HOME")

	for name in lfs.dir(ws) do
		attribute = lfs.symlinkattributes(ws .. "/" .. name)
		if attribute.mode == "link" then
			target = attribute.target:gsub("/*$", "")
			table.insert(links, {name = name,
								target = target,
								len=target:len()})
		end
	end

	return links
end

local function get_path_in_ws(path)
	local relapath, tlen
	local matchedTarget = {}

	for i, link in ipairs(get_workspace_links()) do
		if path:startswith(link.target) then
			if #matchedTarget == 0 
				or (#matchedTarget == 1 and link.len > matchedTarget.len)
			then
				matchedTarget = link
			end
		end
	end

	if #matchedTarget.name  then
		return matchedTarget.name .. path:sub(matchedTarget.len + 1)
	else
		return nil
	end
end

function Link:copyJoplinLink(with_frag)
	local filename = vim.fn.expand("%:p:t")
	local id = utils.parse_joplin_file_name(filename)
	local fragment
	local title = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

	if with_frag then
		local c = vim.api.nvim_win_get_cursor(0)
		fragment = self:find_fragment(c[1], false)
	end

	if with_frag and fragment then
		return vim.fn.setreg("+",
			("[%s](:/%s#%s)"):format(title, id, fragment))
	else
		return vim.fn.setreg("+",
			("[%s](:/%s)"):format(title, id))
	end
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

function Link:open()
	self.handlers[self.schema](self)
end

function Link:resolv()
    vim.fn.system("open -R " .. self.path)
end

function Link:copy()
	if self.schema == "joplin" then
		return vim.fn.setreg("+", ("%s"):format(self.id))
	else
		--return vim.fn.setreg("+", ("%s"):format(self.url))
	end
end

return Link
