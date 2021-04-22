local Range = require"wr.Range"
local R = require"lamda"
local Line = require"wr.Line"
local WrappedRange = require"wr.WrappedRange"

local function fetchMdHeader()
    local range = Range:newFromVisual()

    return R.reverse(R.filter(Line.isHeader,
        R.map(function (lineNr)
                return Line:new(lineNr)
            end,
            R.range(range.start.line, range.stop.line + 1))))
end

local M = {}

M.createOrderedList = function()
    local range = Range:newFromVisual()
    local o = 1

    R.forEach(function (ln)
        local l = Line:new(ln)
        if not l:isBlank() then
            l:addMdOrderListPrefix(o)
            o = o+1
        end
    end,
    R.range(range.start.line, range.stop.line + 1)
    )
end

M.createUnOrderedList = function ()
    local range = Range:newFromVisual()

    R.forEach(function (ln)
        local l = Line:new(ln)
        if not l:isBlank() then
            l:addMdUnOrderListPrefix()
        end
    end,
    R.range(range.start.line, range.stop.line + 1)
    )
end

M.deleteList = function ()
    local range = Range:newFromVisual()
    R.forEach(function (ln)
        local l = Line:new(ln)
        l:removeMdListPrefix()
    end,
    R.range(range.start.line, range.stop.line + 1)
    )
end

M.multiHeaderLevelUp = function ()
    R.map(Line.headerLevelUp, fetchMdHeader())
end

M.multiHeaderLevelDown = function ()
    R.map(Line.headerLevelDown, fetchMdHeader())
end

M.headerLevelUp = function ()
    Line:new():headerLevelUp()
end

M.headerLevelDown = function ()
    Line:new():headerLevelDown()
end

M.createCodeBlock = function ()
    Range:newFromVisual():mdCreateCodeBlock()
end


M.createCodeBlockFromTable = function ()
    Range:newFromVisual():mdCreateCodeBlockFromeTable()
end

M.createCodeBlockFromeCodeLine = function ()
    Range:newFromVisual():mdCreateCodeBlockFromeCodeLine()
end

local function addSepByVisual(left, right)
    WrappedRange:newFromVisual():add_sep(left, right)
end

function M.addQuoteByVisual()
    addSepByVisual('"', '"')
end
function M.addBoldByVisual()
    addSepByVisual("**", "**")
end
function M.addItalicByVisual()
    addSepByVisual("*", "*")
end
function M.addInlineCodeByVisual()
    addSepByVisual("`", "`")
end

local function toggleSepByWord(left, right)

    local r = WrappedRange:newFromSep(left, right)

    if R.isNil(r)then
        r = WrappedRange:newFromCursor()
        if r.inner.start.col == nil then r.inner.start:moveToLineBegin() end
        if r.inner.stop.col == nil then r.inner.stop:moveToLineEnd() end

        return r:add_sep(left, right)
    else
        return r:remove_sep()
    end
end

function M.toggleQuoteByWord()
    toggleSepByWord('"', '"')
end
function M.toggleBoldByWord()
    toggleSepByWord("**", "**")
end
function M.toggleItalicByWord()
    toggleSepByWord("*", "*")
end
function M.toggleInlineCodeByWord()
    toggleSepByWord("`", "`")
end

return M
