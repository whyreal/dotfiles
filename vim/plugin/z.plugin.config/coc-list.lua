local keymap = vim.api.nvim_set_keymap

---@type MapOptions
local opts = {
    silent = true,
    nowait = true,
}

keymap('n', '<leader>la', ':CocList diagnostics<CR>', opts)
keymap('n', '<leader>lb', ':CocList buffers<CR>', opts)
keymap('n', '<leader>lc', ':CocList commands<CR>', opts)
keymap('n', '<leader>le', ':CocList extensions<cr>', opts)
keymap('n', '<leader>lf', ':CocList files<CR>', opts)
keymap('n', '<leader>lj', ':CocNext<CR>', opts)
keymap('n', '<leader>lk', ':CocPrev<CR>', opts)
keymap('n', '<leader>ll', ':CocList<CR>', opts)
keymap('n', '<leader>lo', ':CocList outline<cr>', opts)
keymap('n', '<leader>lr', ':CocList Resume<CR>', opts)
keymap('n', '<leader>lm', ':CocList mru<CR>', opts)
keymap('n', '<leader>ls', ':CocList -I symbols<CR>', opts)

keymap('x', '<leader>la', ':<C-U>CocList diagnostics<CR>', opts)
keymap('x', '<leader>lb', ':<C-U>CocList buffers<CR>', opts)
keymap('x', '<leader>lc', ':<C-U>CocList commands<CR>', opts)
keymap('x', '<leader>le', ':<C-U>CocList extensions<cr>', opts)
keymap('x', '<leader>lf', ':<C-U>CocList files<CR>', opts)
keymap('x', '<leader>lj', ':<C-U>CocNext<CR>', opts)
keymap('x', '<leader>lk', ':<C-U>CocPrev<CR>', opts)
keymap('x', '<leader>ll', ':<C-U>CocList<CR>', opts)
keymap('x', '<leader>lo', ':<C-U>CocList outline<cr>', opts)
keymap('x', '<leader>lr', ':<C-U>CocList Resume<CR>', opts)
keymap('x', '<leader>lm', ':<C-U>CocList mru<CR>', opts)
keymap('x', '<leader>ls', ':<C-U>CocList -I symbols<CR>', opts)