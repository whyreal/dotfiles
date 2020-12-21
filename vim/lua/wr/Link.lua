local WrappedRange = require("wr.WrappedRange")

Link = { }

function Link:new ()
	local txt, _start, _end, _link

	local o = {}
	setmetatable(o, self)
	self.__index = self

	local tr = WrappedRange:newFromSep("[", ")", false) or WrappedRange:newFromCursor()

	txt = tr:get_all()[1]

	if txt:startswith('[') then
		_start, _end, o.id, _link = txt:find('%[([^%]]+)%]%((.*)%)')
	else
		_link = txt
	end

	if _link:len() == 0 then return o end 

	if _link:contain("%s") then
		_start, _end, _link, o.title = _link:find('(%S+)%s+(%S*)')
	end

	if _link:startswith('#') then o.proto = 'anchor' end
	if _link:contain('#') then
		_start, _end, _link, o.anchor = _link:find('([^%s#]*)#([^%s#]*)')
	end

	if _link:contain('://') then
		_start, _end, o.proto, o.url = _link:find('(%a+)://([^%s]+)')
	else
		o.proto = 'file'
		o.url = _link
	end

	return o
end

function Link:copyRWrokspace()
	local lfs = require("lfs")

	local attribute
	local ws = vim.fn.getcwd()
	local links = {}
	links["."] = ws
	links["~"] = vim.fn.getenv("HOME")

	for name in lfs.dir(ws) do
		attribute = lfs.symlinkattributes(ws .. "/" .. name)
		if attribute.mode == "link" then
			links[name] = attribute.target
		end
	end

	local path = vim.fn.expand("%:p")
	local start, stop, pathRWrokspace
	local maxTarget = 0
	for name, target in pairs(links) do
		if path:startswith(target) then
			tlen  = target:len()
			if tlen > maxTarget then
				maxTarget = tlen
				pathRWrokspace = name .. path:sub(tlen + 1)
			end
		end
	end

	pathRWrokspace = pathRWrokspace or path

	local anchor = self:getAnchor()
	return vim.fn.setreg("+", ("[%s](%s#%s)"):format(anchor, pathRWrokspace, anchor))
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
			_, _, anchor = txt:find("#+%s+(.*)%s*")
			return anchor:gsub("%s", "_")
		end
	end
end

function Link:gotoAnchor()
    local txt, lnr

	for i = 1, vim.api.nvim_buf_line_count(0) do
		local txt = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

		if txt:startswith('#') and txt:gsub("%s", "_"):find(self.anchor, 0, true) then
			lnr = i
			break
		end
	end

	vim.api.nvim_win_set_cursor(0, {lnr, 0})
	vim.cmd("normal zt")
	vim.cmd("normal zO")
end

function Link:open ()
	if not self.proto then return end

	if self.proto:startswith("http") then
		local _cmd

		if self.anchor then
			_cmd = ("open %s://%s#%s"):format(self.proto, self.url, self.anchor)
		else
			_cmd = ("open %s://%s"):format(self.proto, self.url)
		end

		return vim.fn.system(_cmd)
	end

	if self.proto == 'anchor' then
		self:gotoAnchor()
    end

	if self.proto == 'file' then
		vim.cmd(("edit %s"):format(self.url) )
		self:gotoAnchor()
	end
end

return Link
