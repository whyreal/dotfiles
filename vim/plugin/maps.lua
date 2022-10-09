-- vim: fdm=marker
local keymap = vim.api.nvim_set_keymap

---@type MapOptions
local opts = {noremap = true}
local plug_opts = {}

keymap('n', 'j', 'gj', opts)
keymap('n', 'k', 'gk', opts)

keymap('n', '<localleader>s', '<cmd>w<CR>', opts)
keymap('n', '<localleader>w', '<Plug>TranslateW', plug_opts)
keymap('x', '<localleader>w', '<Plug>TranslateW', plug_opts)
keymap('n', '<localleader>e', '<cmd>Explore<CR>', opts)
keymap('n', '<localleader>t', '<cmd>CocCommand explorer<CR>', opts)

-- s -- scroll {{{
--keymap('n', 's', '<NOP>', opts)
--keymap('n', 'ss', 's', opts)
--keymap('n', 'sk', '<c-u>', opts)
--keymap('n', 'sj', '<c-d>', opts)
--keymap('n', 'sl', '<c-f>', opts)
--keymap('n', 'sh', '<c-b>', opts)
--keymap('n', 'st', 'zt', opts)
--keymap('n', 'sb', 'zb', opts)
--keymap('n', 'sm', 'zz', opts)

--keymap('x', 's', '<NOP>', opts)
--keymap('x', 'ss', 's', opts)
--keymap('x', 'sk', '<c-u>', opts)
--keymap('x', 'sj', '<c-d>', opts)
--keymap('x', 'sl', '<c-f>', opts)
--keymap('x', 'sh', '<c-b>', opts)
--keymap('x', 'st', 'zt', opts)
--keymap('x', 'sb', 'zb', opts)
--keymap('x', 'sm', 'zz', opts)
-- }}}
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

keymap('n', 'gj', '<cmd>HopLineAC<cr>', opts)
keymap('n', 'gk', '<cmd>HopLineBC<cr>', opts)
keymap('n', 'gp', '<cmd>HopPattern<cr>', opts)
keymap('n', 'gw', '<cmd>HopWordAC<cr>', opts)
keymap('n', 'gb', '<cmd>HopWordBC<cr>', opts)

keymap('x', 'gj', '<cmd>HopLineAC<cr>', opts)
keymap('x', 'gk', '<cmd>HopLineBC<cr>', opts)
keymap('x', 'gp', '<cmd>HopPattern<cr>', opts)
keymap('x', 'gw', '<cmd>HopWordAC<cr>', opts)
keymap('x', 'gb', '<cmd>HopWordBC<cr>', opts)

-- GoTo code navigation.
keymap('n', 'gd', ' <Plug>(coc-definition)', plug_opts)
keymap('n', 'gi', ' <Plug>(coc-implementation)', plug_opts)
keymap('n', 'gy', ' <Plug>(coc-type-definition)', plug_opts)
keymap('n', 'gr', ' <Plug>(coc-references)', plug_opts)

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keymap('n', 'g[', '<Plug>(coc-diagnostic-prev)', plug_opts)
keymap('n', 'g]', '<Plug>(coc-diagnostic-next)', plug_opts)

--}}}

-- v -- visual{{{
--keymap('n', 'v', '<NOP>', opts)
--keymap('n', 'vv', 'v', opts)
--keymap('n', 'vl', '<s-v>', opts)
--keymap('n', 'vc', '<c-v>', opts)

--keymap('x', 'v', '<NOP>', opts)
--keymap('x', 'vv', 'v', opts)
--keymap('x', 'vl', '<s-v>', opts)
--keymap('x', 'vc', '<c-v>', opts)
--}}}
-- <leader>f -- picker {{{
keymap('n', '<leader>fc', ':CocList commands<cr>', opts)
keymap('x', '<leader>fc', ':<C-U>CocList commands<cr>', opts)
keymap('n', '<leader>fb', ':CocList buffers<cr>', opts)
keymap('n', '<leader>fw', ':CocList <cr>', opts)
keymap('n', '<leader>ff', ':CocList --regex --ignore-case files<cr>', opts)
keymap('n', '<leader>fm', ':CocList mru<cr>', opts)
--keymap('n', '<leader>fg', ':CocList grep<cr>', opts)
--keymap('n', '<leader>fl', ':CocList<cr>', opts)
keymap('n', '<leader>fl', ':CocList lines<cr>', opts)
keymap('n', '<leader>fa', ':CocList diagnostics<cr>', opts)
keymap('n', '<leader>fr', ':CocList CocListResume<cr>', opts)
-- }}}
-- <leader>w -- window {{{
--keymap('n', 'w', '<NOP>', opts)
--keymap('n', 'ww', 'w', opts)

keymap('n', '<leader>wt', '<Plug>(coc-terminal-toggle)', plug_opts)

keymap('n', '<leader>wo', '<c-w>o', opts)

keymap('n', '<leader>wj', '<c-w>j', opts)
keymap('n', '<leader>wh', '<c-w>h', opts)
keymap('n', '<leader>wk', '<c-w>k', opts)
keymap('n', '<leader>wl', '<c-w>l', opts)

keymap('n', '<leader>wq', '<c-w>q', opts)
keymap('n', '<leader>wn', '<c-w>w', opts)
keymap('n', '<leader>wp', '<c-w>W', opts)
keymap('n', '<leader>wc', '<c-w>n', opts)
keymap('n', '<leader>wm', '<c-w>p', opts)
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
-- }}}
-- <leader>t -- tab{{{
--keymap('n', 't', '<NOP>', opts)
--keymap('n', 'tt', 't', opts)

keymap('n', '<leader>tn', 'gt', opts)
keymap('n', '<leader>tp', 'gT', opts)
keymap('n', '<leader>tm', 'g<TAB>', opts)
keymap('n', '<leader>tc', '<cmd>tabnew<cr>', opts)
keymap('n', '<leader>tq', '<cmd>tabclose<cr>', opts)
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
--keymap('n', 'b', '<NOP>', opts)
--keymap('n', 'bb', 'b', opts)

keymap('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
keymap('n', '<leader>bn', '<cmd>bnext<CR>', opts)
keymap('n', '<leader>bd', '<cmd>Bdelete<CR>', opts)
--keymap('n', '<leader>bd', '<cmd>bdelete<CR>', opts)
keymap('n', '<leader>bm', '<c-^>', opts)
--}}}

-- <a-cr> -- send-command & coc-list{{{
-- send
keymap('n', '<a-cr>', '<Plug>(coc-command-send-line)', plug_opts)
keymap('x', '<a-cr>', '<Plug>(coc-command-send-range)', plug_opts)
keymap('i', '<a-cr>', '<c-\\><c-o><Plug>(coc-command-send-line)', plug_opts)
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
-- misc {{{
--keymap('n', '<leader>fc', '<cmd>lua require("telescope.builtin").commands()<cr>', opts)
--keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers({ sort_mru=true, cwd_only=true })<cr>', opts)
--keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', opts)
--keymap('n', '<leader>fm', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', opts)
--keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
--keymap('n', '<leader>fl', '<cmd>lua require("telescope.builtin").builtin()<cr>', opts)
--keymap('n', '<leader>fa', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
-- }}}
