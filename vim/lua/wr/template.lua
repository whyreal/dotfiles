local M = {}
local template = require "resty.template"

function M.set(firstline, lastline)
    M.view = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    M.view = table.concat(M.view, "\n")
end

function M.render(firstline, lastline)
    local data_lines = vim.api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    for _, data in ipairs(data_lines) do
        local output = template.process(M.view, {d = string.split(data)})
        vim.api.nvim_buf_set_lines(0, lastline, lastline, false, string.split(output, "\n"))
    end
end

return M