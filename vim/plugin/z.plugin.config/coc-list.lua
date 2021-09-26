local keymap = vim.api.nvim_set_keymap

---@type MapOptions
local opts = {
    silent = true,
    nowait = true,
}

keymap('n', '<leader>la', ':CocList diagnostics<CR>', opts)
keymap('n', '<leader>lb', ':CocList buffers<CR>', opts)
keymap('n', '<leader>lc', ':CocList diagnostics<CR>', opts)
keymap('n', '<leader>le', ':CocList extensions<cr>', opts)
keymap('n', '<leader>lf', ':CocList files<CR>', opts)
keymap('n', '<leader>lj', ':CocNext<CR>', opts)
keymap('n', '<leader>lk', ':CocPrev<CR>', opts)
keymap('n', '<leader>ll', ':CocList<CR>', opts)
keymap('n', '<leader>lo', ':CocList outline<cr>', opts)
keymap('n', '<leader>lr', ':CocList Resume<CR>', opts)
keymap('n', '<leader>lm', ':CocList mru<CR>', opts)
keymap('n', '<leader>ls', ':ocList -I symbols<CR>', opts)

keymap('x', '<leader>la', ':CocList diagnostics<CR>', opts)
keymap('x', '<leader>lb', ':CocList buffers<CR>', opts)
keymap('x', '<leader>lc', ':CocList diagnostics<CR>', opts)
keymap('x', '<leader>le', ':CocList extensions<cr>', opts)
keymap('x', '<leader>lf', ':CocList files<CR>', opts)
keymap('x', '<leader>lj', ':CocNext<CR>', opts)
keymap('x', '<leader>lk', ':CocPrev<CR>', opts)
keymap('x', '<leader>ll', ':CocList<CR>', opts)
keymap('x', '<leader>lo', ':C-u>CocList outline<cr>', opts)
keymap('x', '<leader>lr', ':CocList Resume<CR>', opts)
keymap('x', '<leader>lm', ':C-U>CocList mru<CR>', opts)
keymap('x', '<leader>ls', ':C-U>CocList -I symbols<CR>', opts)
