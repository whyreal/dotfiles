
local imap = {}

imap.cr = function ()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn["complete_info"]()["selected"] ~= -1 then
            vim.fn["completion#wrap_completion"]()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-e><CR>", true, false, true), 'n', true)
        end
    else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), 'n', true)
    end
    return ""
end

imap.tab = function ()
    if vim.fn.pumvisible() ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-n>", true, false, true), 'n', true)
    elseif vim.fn["vsnip#available"](1) ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-!>sej", true, false, true), 't', true)
    elseif imap.check_back_space() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), 'n', true)
    else
        vim.fn["completion#trigger_completion"]()
    end
    return ""
end

imap.stab = function ()
    if vim.fn.pumvisible() ~= 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, false, true), 'n', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-h>", true, false, true), 'n', true)
    end
end

return imap