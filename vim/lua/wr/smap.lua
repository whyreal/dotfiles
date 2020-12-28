local utils = require'wr.utils'
local smap = {}

smap.tab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        return utils.esc("<Plug>(vsnip-jump-next)", true, false, true)
    else
        return utils.esc("<Plug>(vsnip-jump-prev)", true, false, true)
    end
end

smap.stab = function ()
    if vim.fn["vsnip#jumpable(1)"] ~= 0 then
        return utils.esc("<Plug>(vsnip-jump-prev)", true, false, true)
    else
        return utils.esc("<S-Tab>", true, false, true)
    end
end

return smap
