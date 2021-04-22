local r = require("wr.Rest")

local M = {}

M.send = function ()
    r.createReq():sendCurlToTmux()
end

return M
