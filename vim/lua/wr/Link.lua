local WrappedRange = require("wr.WrappedRange")
local mimetypes = require("mimetypes")
local lfs = require("lfs")
local lpeg = require("lpeg")
lpeg.locale(lpeg) 

local Link = {}

local function extension (filename)
    return filename:match(".+%.([%a%d]+)$")
end

local function parse_link(s)
	local V = lpeg.V
	local p = lpeg.P{
		"LINK",
		LINK = V'md_link'
		     + V'normal_link',

		md_link = "[" * V'id' * "]"
		        * "(" * V'normal_link'^-1 * V'title'^-1 * ")",
		id = lpeg.Cg(V'c2', "id"),
		title = lpeg.space^1 * lpeg.Cg(V'c2', "title"),

		normal_link = V'h' * V'p'
		            + V'p' * lpeg.Cg(lpeg.Cc("file"), "schema")
		            + V'fragment' * lpeg.Cg(lpeg.Cc("fragment"), "schema"),

		h = V'schema'^-1 * V'host' * V'port'^-1,
		host = lpeg.Cg(V'c3' * ("." * V'c3')^1, "host"),
		schema = lpeg.Cg(V'c', "schema") * "://",
		port = ":" * lpeg.Cg(lpeg.digit^-5, "port"),

		p = V'path' * V'query'^-1 * V'fragment'^-1,
		query = "?" * lpeg.Cg(V'c', "query"),
		fragment = "#" * lpeg.Cg(V'c', "fragment"),
		path = lpeg.Cg(lpeg.S("~/.")^-3 * V'c' * ("/" * V'c')^0 * lpeg.P"/"^-1, "path"),

		c = (lpeg.P(1) - lpeg.S(" \t\n/[]()@:?#"))^0,
		c2 = (lpeg.P(1) - lpeg.S("\t\n/[]()@:?#"))^0,
		c3 = (lpeg.alnum + lpeg.S("-_"))^1,
	}

	return lpeg.match(lpeg.Ct(p), s)
end

function Link:new()
    local tr = WrappedRange:newFromSep("[", ")", false) or
               WrappedRange:newFromCursor()

    local s = tr:get_all()[1]
    local o = parse_link(s)
    setmetatable(o, self)
    self.__index = self

	if o.schema == "file" then
		o.schema = lfs.symlinkattributes(o.path).mode
	end

	if o.schema == "file" then
		local t = mimetypes.guess(o.path, require("wr.mimedb"))
		if t:startswith("text") then
			o.schema = "text"
		else
			o.schema = "system"
		end
	end

    return o
end

function Link:handler_http()
    local _cmd

	_cmd = ("open -a Firefox.app %s://%s"):format(self.schema, self.host)

	_cmd = _cmd .. (self.path or "")
	_cmd = _cmd .. (self.query and ("?%s"):format(self.query) or "")
	_cmd = _cmd .. (self.fragment and ("#%s"):format(self.fragment) or "")

    vim.fn.system(_cmd)
end

function Link:handler_https() self:handler_http() end

function Link:handler_fragment() self:gotoFragment() end

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

function Link:copyRWrokspace(no_frag)
    local attribute
    local ws = vim.fn.getcwd()
    local links = {}
    links["."] = ws
    links["~"] = vim.fn.getenv("HOME")

    for name in lfs.dir(ws) do
        attribute = lfs.symlinkattributes(ws .. "/" .. name)
        if attribute.mode == "link" then links[name] = attribute.target end
    end

    local path = vim.fn.expand("%:p")
    local basename = vim.fn.expand("%:t:r")
    local start, stop, pathRWrokspace
    local maxTarget = 0
    local tlen
	for name, target in pairs(links) do
		target, _ = target:gsub("/*$", "")
        if path:startswith(target) then
            tlen = target:len()
            if tlen > maxTarget then
                maxTarget = tlen
                pathRWrokspace = name .. path:sub(tlen + 1)
            end
        end
    end

    pathRWrokspace = pathRWrokspace or path

	if no_frag then
		return vim.fn.setreg("+",
			("[%s](%s)"):format(basename, pathRWrokspace))
	else
		local fragment = self:getFragment()
		return vim.fn.setreg("+",
			("[%s](%s#%s)"):format(fragment, pathRWrokspace, fragment))
	end
end

function Link:copyRBuf()
    local fragment = self:getFragment()
    return vim.fn.setreg("+", ("[%s](#%s)"):format(fragment, fragment))
end

function Link:getFragment()
    local txt, fragment
    local c = vim.api.nvim_win_get_cursor(0)

    for i = c[1], 1, -1 do
        txt = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

        if txt:startswith('#') then
            _, _, fragment = txt:find("#+%s+%[?([^%[%]]+)%]?")
            return fragment:gsub("%s", "_")
        end
    end
end

function Link:gotoFragment()
    local txt
    local lnr

    for i = 1, vim.api.nvim_buf_line_count(0) do
        local txt = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

		if txt:startswith('#') then
			_, _, txt = txt:find("^#+%s+%[?([^%[%]]+)%]?")
			if txt and txt:len() > 0 then
				if txt:gsub("%s", "_") == self.fragment then
					lnr = i
					break
				end
			end
		end
    end

	if not lnr then return end

	vim.api.nvim_win_set_cursor(0, {lnr, 0})
	vim.cmd("normal! zO")
	vim.cmd("normal! zt")
end

function Link:open()
    if not self.schema then
		return
	end

    self["handler_" .. self.schema](self)
end

function Link:resolv()
    if self.schema ~= "file" then
		return
	end

    vim.fn.system("open -R " .. self.path)
end

return Link
