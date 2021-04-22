local R = require("lamda")

local M = {}

function M.getProjects()
    return R.join("\n", R.keys(PROJECTS))
end

function M.exploreProject(name)
    vim.cmd("Explore " .. PROJECTS[name])
end

return M
