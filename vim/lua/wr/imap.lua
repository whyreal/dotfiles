local utils = require'wr.utils'
local imap = {}

imap.cr = function ()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn["complete_info"]()["selected"] ~= -1 then
			vim.fn["completion#wrap_completion"]()
            return ""
        else
            return utils.esc("<c-e><CR>", true, false, true)
        end
    else
            return utils.esc("<CR>", true, false, true)
    end
end

imap.tab = function ()
    if vim.fn.pumvisible() ~= 0 then
        return utils.esc("<c-n>", true, false, true)
    elseif vim.fn["vsnip#available"](1) ~= 0 then
        return utils.esc("<Plug>(vsnip-expand-or-jump)", true, false, true)
    elseif utils.check_back_space() then
        return utils.esc("<Tab>", true, false, true)
    else
		vim.fn["completion#trigger_completion"]()
        return ""
    end
end

imap.stab = function ()
    if vim.fn.pumvisible() ~= 0 then
        return utils.esc("<C-p>", true, false, true)
    else
        return utils.esc("<C-h>", true, false, true)
    end
end

return imap
