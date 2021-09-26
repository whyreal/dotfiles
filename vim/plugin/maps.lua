local keymap = vim.api.nvim_set_keymap

---@type MapOptions
local opts = {}

keymap('c', '<c-a>', '<HOME>', opts)
keymap('c', '<c-e>', '<END>', opts)
keymap('c', '<c-b>', '<Left>', opts)
keymap('c', '<c-f>', '<Right>', opts)
keymap('c', '<a-b>', '<S-Left>', opts)
keymap('c', '<a-f>', '<S-Right>', opts)
vim.o.cedit="<C-x>"

keymap('i', 'kk', '<ESC>', opts)

keymap('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
keymap('n', '<leader>bn', '<cmd>bnext<CR>', opts)
keymap('n', '<leader>bd', '<cmd>bd<CR>', opts)
keymap('n', '<leader>bo', '<c-^>', opts)

keymap('n', '<leader>w', '<cmd>w<CR>', opts)

keymap('n', '<a-=>', '<cmd>split term://$SHELL<CR>', opts)

keymap('n', '<leader>ee', '<cmd>Explore<CR>', opts)
keymap('n', '<leader>et', '<cmd>Texplore<CR>', opts)
keymap('n', '<leader>es', '<cmd>Sexplore<CR>', opts)
keymap('n', '<leader>ev', '<cmd>Vexplore<CR>', opts)
keymap('n', '<leader>ec', '<cmd>CocCommand explorer<CR>', opts)

keymap('t', '<c-o>', [[<c-\><c-n>]], opts)

keymap('n', '0', '<Plug>(coc-goto-first)', opts)

keymap('n', '<leader>tt', '<Plug>(coc-command-send-line)', opts)
keymap('x', '<leader>tt', '<Plug>(coc-command-send-range)', opts)

--keymap('n', '<c-d>', '<c-d>zz', opts)
--keymap('n', '<c-u>', '<c-u>zz', opts)
