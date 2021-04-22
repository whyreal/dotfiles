local R = require("lamda")
local lpeg = require("lpeg")
lpeg.locale(lpeg)

local Cursor = require"wr.Cursor"
local Line = require"wr.Line"

local M = { }

local function parseRequestTxt(lines)
    local req = {headers = {}}
    local V = lpeg.V
    local P = lpeg.P
    local C = lpeg.C
    local S = lpeg.S

    local p = P{
        "HttpReq";
        HttpReq = (V"varLine" + V"commentLine" + V"blankLine")^0
                * V"ReqLine"
                * V"header"^0
                * ((V"newLine")^2
                * V"body")^-1 * V"newLine"^0,

        varLine = "@" * V"c"^0 * V"newLine",
        commentLine = "#" * V"c"^0 * V"newLine",
        blankLine = V"space"^0 * V"newLine",

        ReqLine = V"method" * V"space"^1 * V"uri" * (V"space"^1 * V"proto")^-1 ,

        method = C(P"POST"
                    + P"GET"
                    + P"DELETE"
                    + P"PUT") / function(method)
                        req.method = method
                    end,
        uri = C(V"w"^1) / function(uri) req.uri = uri end,
        proto = C(V"w"^1) / function(proto) req.proto = proto end,

        header = V"newLine"
                * C(V"kv"^1) * V"space"^0
                * P":" * V"space"^0
                * C(V"kv"^1) * V"space"^0 / function(k, v)
            req.headers[k] = v
        end,
        body = C(P(1)^0) / function(body) req.body = body end,
        kv = V"w" - P":",
        w = V"c" - V"space",
        c = 1 - V"newLine",
        newLine = P"\n",
        space = S" \t"
        }

    lpeg.match(p, R.join("\n", lines))

    return req
end

function M:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self
    return o
end
function M.fetchRequestLines()
    -- 获取变量定义行
    local varStop

    for i = 1, vim.api.nvim_buf_line_count(0), 1 do
        if R.startsWith("###", Line:new(i).txt) then
            varStop = i - 1
            break
        end
    end
    if R.isNil(varStop) then return nil end

    local varLines = vim.api.nvim_buf_get_lines(0, 0, varStop, false)

    -- 获取 request 定义行
    local reqStart, reqStop

    for i = Cursor.current().line, 1, -1 do
        if R.startsWith("###", Line:new(i).txt) then
            reqStart = i
            break
        end
    end
    reqStart = reqStart or 1

    for i = Cursor.current().line+1, vim.api.nvim_buf_line_count(0), 1 do
        if R.startsWith("###", Line:new(i).txt) then
            reqStop = i - 1 -- read the line before next "###"
            break
        end
    end
    reqStop = reqStop or vim.api.nvim_buf_line_count(0)
    return R.concat(varLines, vim.api.nvim_buf_get_lines(0, reqStart, reqStop, false))
end

function M.createReq()
    local vars = {}

    local l = R.map(function (line)
        return M.replaceVar(line, vars)
    end, M.fetchRequestLines())

    return M:new(parseRequestTxt(l))
end

function M.replaceVar(txt, vars)
    local V = lpeg.V
    local P = lpeg.P
    local C = lpeg.C
    local S = lpeg.S

    -- 变量替换
    local p = P{
        "Line";
        Line = lpeg.Cs((V"var" + 1)^0),
        var = "{{" * C((P(1) - S"{}")^1) * "}}" / function (name)
            return vars[name] or ("{{" .. name .. "}}")
        end
    }
    local line = lpeg.match(p, txt)

    -- 执行变量定义
    local p1 = P{
        "Line";
        Line = "@" * C((1 - S"@=" - lpeg.space)^1)
             * lpeg.space^0 * "="  * lpeg.space^0
             * C((1 - S"@=" - lpeg.space)^1) / function (k,v)
                 vars[k] = v
             end
    }
    lpeg.match(p1, line)

    return line
end

function M:sendCurlToTmux()
    self:getCurlCmd()
    local cmd = R.replace('"', '\\"', 0, self.cmd)
	vim.fn.system('tmux send-keys "' .. cmd .. '" ENTER')
end

function M:getCurlCmd()
    self.cmd = "curl '" .. self.uri .. "' "
        .. "-X " .. self.method

    if not R.isEmpty(self.headers) then
        self.cmd = self.cmd .. " " .. R.reduce(R.concat, "", R.map(
            function (h)
                return "-H '" .. h .. ": " .. self.headers[h] .. "' "
            end,
            R.keys(self.headers)))
    end

    if not R.isNil(self.body) then
        self.cmd = self.cmd  .. "-d '" .. self.body .. "'"
    end
end

return M
