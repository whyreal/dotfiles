local WrappedRange = require("wr.WrappedRange")
local mimetypes = require("mimetypes")
local lfs = require("lfs")
local utils = require("wr.utils")
local R = require("lamda")
local opener = require("wr.LinkOpener")
local Range = require("wr.Range")
local Cursor = require("wr.Cursor")

local Link = {}

local function detectMarkdownUrl()
	local c = Cursor:newFromVim(vim.api.nvim_win_get_cursor(0))
	local txt = vim.api.nvim_buf_get_lines(0, c.line - 1, c.line, false)[1]
	local l, r, url, title, range

	l, _ = txt:find_left('[', c.col, true)
	if l then
		url = string.match(txt, "](%b())", l)
		if url then
			url = string.sub(url, 2, -2)

			title = string.match(url, '%b""')
			if title then
				url = string.sub(url, 1, -1 - title:len()):rstrip()
				title = string.sub(title, 2, -2)
			end
			return url
		else
			return nil
		end
	end

	l, _ = txt:find_left('<', c.col, true)
	if l then
		url = string.match(txt, "(%b<>)", l)
		if url then
			return string.sub(url, 2, -2)
		else
			return nil
		end
	end

	range = Range:newFromCursor(c)

	return string.sub(txt, range.start.col, range.stop.col)
end

function Link:new()
    local url = detectMarkdownUrl()

    local parsedUrl = utils.parse_link(url)
	assert(type(parsedUrl) == "table", "Can't parse link!!!")
    setmetatable(parsedUrl, self)
    self.__index = self

	if parsedUrl.path then
		parsedUrl.path = vim.fn.expand(parsedUrl.path)
	end

	--
	-- detect the type of url
	--
	if parsedUrl.schema == "ws" then
        -- workspace path
        parsedUrl.schema = "file"
        parsedUrl.path = vim.fn.simplify(vim.g.ws .. "/" .. parsedUrl.path)
    elseif parsedUrl.schema == "file" then
        -- 相对路径
        parsedUrl.path = vim.fn.simplify(vim.fn.expand("%:h:p") .. "/" .. parsedUrl.path)
    end

	-- directory or link
	if parsedUrl.schema == "file" then
	    local a = lfs.symlinkattributes(parsedUrl.path)
		if a then
			parsedUrl.schema = a.mode
		end
	end

	-- file type: text or other(will be opened by system application)
	if parsedUrl.schema == "file" then
		local t = mimetypes.guess(utils.parse_path(parsedUrl.path).filename, require("wr.mimedb"))

		if t and R.startsWith("text", t) then
			parsedUrl.schema = "text"
		else
			parsedUrl.schema = "system"
		end
	end

    return parsedUrl
end

local function getDirEntrieAttr(path)
	local entries = {}
	for name in lfs.dir(path) do
		table.insert(entries, name)
	end

	return R.concat({
			{name = "~", target = HOME, mode = "link"},
			{name = ".", target = path, mode = "link"}
		},
		R.map(function (name)
			local attribute = lfs.symlinkattributes(path .. "/" .. name)
			attribute.name = name
			return attribute
		end, entries))
end

local isLink = R.filter(R.propEq('mode', 'link'))

local inWorkspace = function (path)
	return R.filter(
		function (i)
			return R.startsWith(i.target, path)
		end
	)
end

local longestTarget = R.reduce(R.maxBy(function (l)
	return l.target:len()
end), {target = ""})

local function get_path_in_ws(path)

	local ws = vim.fn.getcwd()
	local t = R.pipe(isLink, inWorkspace(path), longestTarget)(getDirEntrieAttr(ws))

	if not t.name then return path end

	return t.name .. path:sub(t.target:len() + 1)
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
	local path = get_path_in_ws(vim.fn.expand("%:p"))

	local fragment

	if with_frag then
		local c = vim.api.nvim_win_get_cursor(0)
		fragment = self:find_fragment(c[1], false)
	end

	-- finded frag?
	if with_frag and fragment then
		return vim.fn.setreg("+",
			("[%s](%s#%s)"):format(fragment, path, fragment))
	else
		local basename = path:gsub(".*/", ""):gsub("%..*", "")
		return vim.fn.setreg("+",
			("[%s](%s)"):format(basename, path))
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

	-- find 有两个方向：先前或者向后
    start = start or (after and 1 or vim.api.nvim_buf_line_count(0))
	local stop = after and vim.api.nvim_buf_line_count(0) or 1
	local step = after and 1 or -1

    for i = start, stop, step do
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
	opener[self.schema](self)
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
