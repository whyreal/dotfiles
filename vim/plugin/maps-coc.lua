-- vim: fdm=marker
local keyset = vim.keymap.set

local opts = {noremap = true, nowait = true}
-- local opts = {noremap = true, silent = true, nowait = true}
local plug_opts = {}

-- <leader>e -- file explorer {{{
keyset('n', '<leader>es', '<cmd>CocCommand explorer --toggle --position left<CR>', opts)
keyset('n', '<leader>et', '<cmd>CocCommand explorer --toggle --position tab<CR>', opts)
keyset('n', '<leader>ef', '<cmd>CocCommand explorer --toggle --position floating<CR>', opts)
keyset('n', '<leader>ee', '<cmd>CocCommand explorer --toggle<CR>', opts)
-- }}}

-- <leader>f -- picker {{{
keyset('n', '<leader>sc', ':CocList commands<cr>', opts)
keyset('x', '<leader>sc', ':<C-U>CocList commands<cr>', opts)

keyset('n', '<leader>sf', ':CocList files<cr>', opts)
keyset('n', '<leader>sm', ':CocList mru<cr>', opts)
keyset('n', '<leader>sl', ':CocList lines<cr>', opts)
keyset('n', '<leader>sg', ':grep ', opts)
keyset('n', '<leader>so', ':CocList outline<cr>', opts)
--keyset('n', '<leader>sl', ':CocList<cr>', opts)

--keyset('n', '<leader>sa', ':CocList diagnostics<cr>', opts)
-- }}}

-- Manage extensions
keyset("n", "<leader>se", ":<C-u>CocList extensions<cr>", opts)
-- Search workspace symbols
keyset("n", "<leader>ss", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
keyset("n", "<leader>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<leader>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
keyset("n", "<leader>p", ":<C-u>CocListResume<cr>", opts)
