-- vim: fdm=marker
local keyset = vim.keymap.set

local opts = {noremap = true}
local plug_opts = {}

-- <leader>e -- file explorer {{{
keyset('n', '<leader>es', '<cmd>CocCommand explorer --toggle --position left<CR>', opts)
keyset('n', '<leader>et', '<cmd>CocCommand explorer --toggle --position tab<CR>', opts)
keyset('n', '<leader>ef', '<cmd>CocCommand explorer --toggle --position floating<CR>', opts)
keyset('n', '<leader>ee', '<cmd>CocCommand explorer --toggle<CR>', opts)
-- }}}

-- <leader>f -- picker {{{
keyset('n', '<leader>fc', ':CocList commands<cr>', opts)
keyset('x', '<leader>fc', ':<C-U>CocList commands<cr>', opts)

keyset('n', '<leader>ff', ':CocList --regex --ignore-case files<cr>', opts)
keyset('n', '<leader>fm', ':CocList mru<cr>', opts)
keyset('n', '<leader>fl', ':CocList lines<cr>', opts)
keyset('n', '<leader>fg', ':grep ', opts)
keyset('n', '<leader>fo', ':CocList outline<cr>', opts)
--keyset('n', '<leader>fl', ':CocList<cr>', opts)

--keyset('n', '<leader>fa', ':CocList diagnostics<cr>', opts)
--keyset('n', '<leader>fr', ':CocList CocListResume<cr>', opts)
-- }}}
