-- vim: fdm=marker
local keymap = vim.api.nvim_set_keymap

---@type MapOptions
local opts = {noremap = true}
local plug_opts = {}

keymap('n', '<leader>s', '<cmd>w<CR>', opts)
keymap('n', '<localleader>w', '<Plug>TranslateW', plug_opts)
keymap('x', '<localleader>w', '<Plug>TranslateW', plug_opts)


-- s -- scroll {{{
keymap('n', 's', '<NOP>', opts)
keymap('n', 'se', '<c-e>', opts)
keymap('n', 'sy', '<c-y>', opts)
keymap('n', 'su', '<c-u>', opts)
keymap('n', 'sd', '<c-d>', opts)
keymap('n', 'sf', '<c-f>', opts)
keymap('n', 'sb', '<c-b>', opts)

keymap('x', 's', '<NOP>', opts)
keymap('x', 'se', '<c-e>', opts)
keymap('x', 'sy', '<c-y>', opts)
keymap('x', 'su', '<c-u>', opts)
keymap('x', 'sd', '<c-d>', opts)
keymap('x', 'sf', '<c-f>', opts)
keymap('x', 'sb', '<c-b>', opts)
-- }}}
-- w -- window {{{
keymap('n', '<leader>wt', '<Plug>(coc-terminal-toggle)', plug_opts)
keymap('n', '<leader>ww', '<c-w>w', opts)
keymap('n', '<leader>wj', '<c-w>j', opts)
keymap('n', '<leader>wh', '<c-w>h', opts)
keymap('n', '<leader>wk', '<c-w>k', opts)
keymap('n', '<leader>wl', '<c-w>l', opts)
keymap('n', '<leader>wq', '<c-w>q', opts)
keymap('n', '<leader>wv', '<c-w>v', opts)
keymap('n', '<leader>ws', '<c-w>s', opts)
keymap('n', '<leader>w1', '1<c-w>w',opts)
keymap('n', '<leader>w2', '2<c-w>w',opts)
keymap('n', '<leader>w3', '3<c-w>w',opts)
keymap('n', '<leader>w4', '4<c-w>w',opts)
keymap('n', '<leader>w5', '5<c-w>w',opts)
keymap('n', '<leader>w6', '6<c-w>w',opts)
keymap('n', '<leader>w7', '7<c-w>w',opts)
keymap('n', '<leader>w8', '8<c-w>w',opts)
keymap('n', '<leader>w9', '9<c-w>w',opts)
keymap('n', '<leader>wn', '<c-w>w', opts)
keymap('n', '<leader>wp', '<c-w>W', opts)
keymap('n', '<leader>wc', '<c-w>n', opts)
keymap('n', '<leader>wo', '<c-w>p', opts)
-- }}}
-- v -- visual{{{
keymap('n', 'vv', 'v', opts)
keymap('n', 'vl', '<s-v>', opts)
keymap('n', 'vc', '<c-v>', opts)
--}}}
-- g -- goto{{{
keymap('n', 'g0', '<Plug>(coc-goto-first)', plug_opts)
keymap('n', 'gm', 'M', opts)
keymap('n', 'gh', 'H', opts)
keymap('n', 'gl', 'L', opts)
keymap('n', 'go', '<c-o>', opts)

keymap('x', 'g0', '<Plug>(coc-goto-first)', plug_opts)
keymap('x', 'gm', 'M', opts)
keymap('x', 'gh', 'H', opts)
keymap('x', 'gl', 'L', opts)

-- Use better keys for the bépo keyboard layout and set
-- a balanced distribution of terminal / sequence keys
require'hop'.setup { keys = 'etovxdygfblzhckisuran', jump_on_sole_occurrence = false }

keymap('n', 'j', 'gj', opts)
keymap('n', 'k', 'gk', opts)
keymap('n', 'gj', '<cmd>HopLineAC<cr>', opts)
keymap('n', 'gk', '<cmd>HopLineBC<cr>', opts)
keymap('n', 'gp', '<cmd>HopPattern<cr>', opts)
keymap('n', 'gw', '<cmd>HopWordAC<cr>', opts)
keymap('n', 'gb', '<cmd>HopWordBC<cr>', opts)

keymap('x', 'j', 'gj', opts)
keymap('x', 'k', 'gk', opts)
keymap('x', 'gj', '<cmd>HopLineAC<cr>', opts)
keymap('x', 'gk', '<cmd>HopLineBC<cr>', opts)
keymap('x', 'gp', '<cmd>HopPattern<cr>', opts)
keymap('x', 'gw', '<cmd>HopWordAC<cr>', opts)
keymap('x', 'gb', '<cmd>HopWordBC<cr>', opts)

-- GoTo code navigation.
keymap('n', 'gd', ' <Plug>(coc-definition)', plug_opts)
keymap('n', 'gy', ' <Plug>(coc-type-definition)', plug_opts)
keymap('n', 'gi', ' <Plug>(coc-implementation)', plug_opts)
keymap('n', 'gr', ' <Plug>(coc-references)', plug_opts)

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keymap('n', 'g[', '<Plug>(coc-diagnostic-prev)', plug_opts)
keymap('n', 'g]', '<Plug>(coc-diagnostic-next)', plug_opts)

--}}}
-- <leader>f -- picker{{{
keymap('n', '<leader>fa', ':CocList diagnostics<CR>', opts)
keymap('n', '<leader>fb', ':CocList buffers<CR>', opts)
keymap('n', '<leader>fc', ':CocList commands<CR>', opts)
keymap('n', '<leader>fe', ':CocList extensions<cr>', opts)
keymap('n', '<leader>ff', ':CocList files<CR>', opts)
keymap('n', '<leader>fl', ':CocList<CR>', opts)
keymap('n', '<leader>fo', ':CocList outline<cr>', opts)
keymap('n', '<leader>fr', ':CocList Resume<CR>', opts)
keymap('n', '<leader>fm', ':CocList mru<CR>', opts)
keymap('n', '<leader>fs', ':CocList -I symbols<CR>', opts)

keymap('x', '<leader>fc', ':<C-U>CocList commands<CR>', opts)
--}}}
-- <leader>t -- tab{{{
keymap('n', '<leader>tn', 'gt', opts)
keymap('n', '<leader>tp', 'gT', opts)
keymap('n', '<leader>tc', '<cmd>tabnew<cr>', opts)
keymap('n', '<leader>tq', '<cmd>tabclose<cr>', opts)
keymap('n', '<leader>tl', '<cmd>tablast<cr>', opts)
keymap('n', '<leader>tf', '<cmd>tabfirst<cr>', opts)
keymap('n', '<leader>t1', '1gt', opts)
keymap('n', '<leader>t2', '2gt', opts)
keymap('n', '<leader>t3', '3gt', opts)
keymap('n', '<leader>t4', '4gt', opts)
keymap('n', '<leader>t5', '5gt', opts)
keymap('n', '<leader>t6', '6gt', opts)
keymap('n', '<leader>t7', '7gt', opts)
keymap('n', '<leader>t8', '8gt', opts)
keymap('n', '<leader>t9', '9gt', opts)
--}}}
-- <leader>b -- buffer{{{
keymap('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
keymap('n', '<leader>bn', '<cmd>bnext<CR>', opts)
keymap('n', '<leader>bd', '<cmd>Bdelete<CR>', opts)
--keymap('n', '<leader>bd', '<cmd>bdelete<CR>', opts)
keymap('n', '<leader>bl', '<c-^>', opts)
--}}}
-- <leader>c -- command{{{
-- send
keymap('n', '<leader>cs', '<Plug>(coc-command-send-line)', plug_opts)
keymap('x', '<leader>cs', '<Plug>(coc-command-send-range)', plug_opts)
--}}}
-- <leader>e -- Explore{{{
keymap('n', '<leader>ee', '<cmd>Explore<CR>', opts)
keymap('n', '<leader>er', '<cmd>Rexplore<CR>', opts)
keymap('n', '<leader>et', '<cmd>Texplore<CR>', opts)
keymap('n', '<leader>es', '<cmd>CocCommand explorer<CR>', opts)
--}}}
-- terminal{{{
--keymap('n', '<a-=>', '<cmd>split term://$SHELL<CR>', opts)
keymap('n', '<a-=>', '<Plug>(coc-terminal-toggle)', plug_opts)
keymap('t', '<c-o>', [[<c-\><c-n>]], opts)
--}}}
-- command line{{{
keymap('c', '<c-a>', '<HOME>', opts)
keymap('c', '<c-e>', '<END>', opts)
keymap('c', '<c-b>', '<Left>', opts)
keymap('c', '<c-f>', '<Right>', opts)
keymap('c', '<a-b>', '<S-Left>', opts)
keymap('c', '<a-f>', '<S-Right>', opts)
vim.o.cedit="<C-x>"
--}}}
