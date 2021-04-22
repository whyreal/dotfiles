local R = require"lamda"
local lpeg = require("lpeg")
lpeg.locale(lpeg)

local patterns = {}
patterns.indent_line = lpeg.Cg(lpeg.space^0) * lpeg.Cg(lpeg.P(1)^0)
patterns.block_line = lpeg.space^0

local M = { }

function M:new(lineNr)
    if R.isNil(lineNr) then
        lineNr = vim.api.nvim_win_get_cursor(0)[1]
    end

    local o = {
        txt = vim.api.nvim_buf_get_lines(0, lineNr - 1, lineNr, false)[1],
        lineNr = lineNr
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function M:isHeader()
    local isHeader = R.startsWith("#", self.txt)
    if isHeader then return true end

    local nextLine = M:new(self.lineNr+1)
    if R.startsWith("===", nextLine.txt)
        or R.startsWith("---", nextLine.txt)
    then
        return true
    end
    return false
end

function M:headerLevelDown()
    self:transSetexttoATX()

    if not R.startsWith("#", self.txt) then
        self.txt = " " .. R.trim(self.txt)
    end
    self.txt = "#" .. self.txt
    return self:update()
end

function M:transSetexttoATX()
    if not R.startsWith("#", self.txt) then
        local nextLine = M:new(self.lineNr+1)
        if R.startsWith("===", nextLine.txt) then
            self.txt = "# " .. R.trim(self.txt)
            nextLine:delete()
        elseif R.startsWith("---", nextLine.txt) then
            self.txt = "## " .. R.trim(self.txt)
            nextLine:delete()
        end
    end
end

function M:headerLevelUp()
    self:transSetexttoATX()

    self.txt = R.trim(string.gsub(self.txt, "^#", "", 1))
    self:update()
end

function M:update()
    vim.api.nvim_buf_set_lines(0, self.lineNr -1, self.lineNr, false, {self.txt})
end

function M:delete()
    vim.api.nvim_buf_set_lines(0, self.lineNr -1, self.lineNr, false, {})
end

function M:insert(txtList)
    vim.api.nvim_buf_set_lines(0, self.lineNr -1, self.lineNr - 1, false, txtList)
end

function M:append(txtList)
    vim.api.nvim_buf_set_lines(0, self.lineNr, self.lineNr, false, txtList)
end

function M:sendToTmux()
    local cmd = R.replace('"', '\\"', 0, R.trim(self.txt))
    cmd = R.replace(';$', '\\;', 1, cmd)
	vim.fn.system('tmux send-keys "' .. cmd .. '" ENTER')
end

function M:getIndent()
    local indent, _ = lpeg.match(patterns.indent_line, self.txt)
    return indent
end

function M:removeBackQuote()
    self.txt = R.trim(self.txt):gsub("[`]", "")
    self:update()
end

function M:isBlank()
    return lpeg.match(patterns.block_line, self.txt) == #self.txt + 1
end

function M:removeMdListPrefix()
    if R.startsWith("-", self.txt) then
        self.txt, _ = self.txt:gsub("^- ", "", 1)
    else
        self.txt, _ = self.txt:gsub("^%d+%. ", "", 1)
    end
    self:update()
end

function M:addMdOrderListPrefix(o)
    self.txt = o .. ". " .. self.txt
    self:update()
end

function M:addMdUnOrderListPrefix()
    self.txt = "- " .. self.txt
    self:update()
end

return M
