local smap = {}

smap.tab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sjn", true, false, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
    end
    return ""
end

smap.stab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sjp", true, false, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), 'n', true)
    end
end

return smap