local WrappedRange = require("wr.WrappedRange")
local mimetypes = require("mimetypes")
local lfs = require("lfs")

local Link = {}

local function extension (filename)
    return filename:match(".+%.([%a%d]+)$")
end

function Link:new()
    local txt, _start, _end, _link

    local o = {}
    setmetatable(o, self)
    self.__index = self

    local tr = WrappedRange:newFromSep("[", ")", false) or
                   WrappedRange:newFromCursor()

    txt = tr:get_all()[1]

    if txt:startswith('[') then
        _start, _end, o.id, _link = txt:find('%[([^%]]+)%]%((.*)%)')
		if _link:contain("%s") then
			_start, _end, _link, o.title = _link:find('(%S+)%s+(%S*)')
		end
    else
        _link = txt
    end
    if _link:len() == 0 then return o end

    if _link:contain('#') then
        _start, _end, _link, o.anchor = _link:find('([^%s#]*)#([^%s#]*)')
		if _link:len() == 0 then
			o.proto = 'anchor'
			return o
		end
    end

    if _link:contain('://') then
        _start, _end, o.proto, o.url = _link:find('(%a+)://([^%s]+)')
    else
		-- file, directory, link, socket, named pipe, char device, block device or other
		local attribute = lfs.symlinkattributes(_link)

        o.proto = attribute.mode
        o.url = _link
    end

    return o
end

function Link:handler_http()
    local _cmd

    if self.anchor then
        _cmd = ("open -a Firefox.app %s://%s#%s"):format(self.proto, self.url,
                                                         self.anchor)
    else
        _cmd = ("open -a Firefox.app %s://%s"):format(self.proto, self.url)
    end

    vim.fn.system(_cmd)
end

function Link:handler_https() self:handler_http() end

function Link:handler_anchor() self:gotoAnchor() end

function Link:handler_scp()
    vim.cmd(("edit %s://%s"):format(self.proto, self.url))
    if self.anchor then self:gotoAnchor() end
end

function Link:handler_file()

	local t = mimetypes.guess(self.url, require("wr.mimedb"))
	if t:startswith("text") then
		vim.cmd(("edit %s"):format(self.url))
		if self.anchor then self:gotoAnchor() end
	else
		local _cmd = "open " .. self.url
		vim.fn.system(_cmd)
	end

end

function Link:handler_directory()
	local _cmd = "open " .. self.url
	vim.fn.system(_cmd)
end

function Link:copyRWrokspace(no_anchor)
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

	if no_anchor then
		return vim.fn.setreg("+",
			("[%s](%s)"):format(basename, pathRWrokspace))
	else
		local anchor = self:getAnchor()
		return vim.fn.setreg("+",
			("[%s](%s#%s)"):format(anchor, pathRWrokspace, anchor))
	end
end

function Link:copyRBuf()
    local anchor = self:getAnchor()
    return vim.fn.setreg("+", ("[%s](#%s)"):format(anchor, anchor))
end

function Link:getAnchor()
    local txt, anchor
    local c = vim.api.nvim_win_get_cursor(0)

    for i = c[1], 1, -1 do
        txt = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

        if txt:startswith('#') then
            _, _, anchor = txt:find("#+%s+%[?([^%[%]]+)%]?")
            return anchor:gsub("%s", "_")
        end
    end
end

function Link:gotoAnchor()
    local txt
    local lnr

    for i = 1, vim.api.nvim_buf_line_count(0) do
        local txt = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

		if txt:startswith('#') then
			_, _, txt = txt:find("^#+%s+%[?([^%[%]]+)%]?")
			if txt and txt:len() > 0 then
				if txt:gsub("%s", "_") == self.anchor then
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
    if not self.proto then
		return
	end

    self["handler_" .. self.proto](self)
end

function Link:resolv()
    if self.proto ~= "file" then
		return
	end

    vim.fn.system("open -R " .. self.url)
end

return Link
