local tmux = require('domain/infra/tmux.lua')
local M = {}

M.sendLine = function (line)
    tmux.sendLine(line)
end

return M