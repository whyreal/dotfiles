-- vim: fdm=marker
local keyset = vim.keymap.set

local opts = {noremap = true}
local plug_opts = {}

--keyset('n', 'j', 'gj', opts)
--keyset('n', 'k', 'gk', opts)

keyset('n', '!', ':!', opts)

keyset('n', '<localleader>s', '<cmd>w<CR>', opts)
keyset('n', '<localleader>w', '<Plug>TranslateW', plug_opts)
keyset('x', '<localleader>w', '<Plug>TranslateW', plug_opts)
keyset('n', '<localleader>e', '<cmd>CocCommand explorer --toggle --position left<CR>', opts)

-- <leader>e -- file explorer {{{
keyset('n', '<leader>es', '<cmd>CocCommand explorer --toggle --position left<CR>', opts)
keyset('n', '<leader>et', '<cmd>CocCommand explorer --toggle --position tab<CR>', opts)
keyset('n', '<leader>ef', '<cmd>CocCommand explorer --toggle --position floating<CR>', opts)
keyset('n', '<leader>ee', '<cmd>CocCommand explorer --toggle<CR>', opts)
-- }}}
--
-- g -- goto{{{
keyset('n', 'gm', 'M', opts)
keyset('n', 'gh', 'H', opts)
keyset('n', 'gl', 'L', opts)

keyset('n', 'go', '<c-o>', opts)
keyset('n', 'gi', '<c-i>', opts)

keyset('x', 'g0', '<Plug>(coc-goto-first)', plug_opts)

keyset('x', 'gm', 'M', opts)
keyset('x', 'gh', 'H', opts)
keyset('x', 'gl', 'L', opts)

keyset('n', 'gj', '<cmd>HopLineAC<cr>', opts)
keyset('n', 'gk', '<cmd>HopLineBC<cr>', opts)
keyset('n', 'gp', '<cmd>HopPattern<cr>', opts)
keyset('n', 'gw', '<cmd>HopWordAC<cr>', opts)
keyset('n', 'gb', '<cmd>HopWordBC<cr>', opts)

keyset('n', 'gc', '<cmd>HopChar2<cr>', opts)

keyset('x', 'gj', '<cmd>HopLineAC<cr>', opts)
keyset('x', 'gk', '<cmd>HopLineBC<cr>', opts)
keyset('x', 'gp', '<cmd>HopPattern<cr>', opts)
keyset('x', 'gw', '<cmd>HopWordAC<cr>', opts)
keyset('x', 'gb', '<cmd>HopWordBC<cr>', opts)
keyset('x', 'gc', '<cmd>HopChar2<cr>', opts)

-- GoTo code navigation.
keyset('n', 'gd', ' <Plug>(coc-definition)', plug_opts)
keyset('n', 'gi', ' <Plug>(coc-implementation)', plug_opts)
keyset('n', 'gy', ' <Plug>(coc-type-definition)', plug_opts)
keyset('n', 'gr', ' <Plug>(coc-references)', plug_opts)

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keyset('n', 'g[', '<Plug>(coc-diagnostic-prev)', plug_opts)
keyset('n', 'g]', '<Plug>(coc-diagnostic-next)', plug_opts)

--}}}
-- s -- scroll {{{
keyset('n', 's', '<NOP>', opts)
keyset('n', 'ss', 's', opts)
keyset('n', 'sk', '<c-u>', opts)
keyset('n', 'sj', '<c-d>', opts)
keyset('n', 'sl', '<c-f>', opts)
keyset('n', 'sh', '<c-b>', opts)
keyset('n', 'st', 'zt', opts)
keyset('n', 'sb', 'zb', opts)
keyset('n', 'sm', 'zz', opts)

keyset('x', 's', '<NOP>', opts)
keyset('x', 'ss', 's', opts)
keyset('x', 'sk', '<c-u>', opts)
keyset('x', 'sj', '<c-d>', opts)
keyset('x', 'sl', '<c-f>', opts)
keyset('x', 'sh', '<c-b>', opts)
keyset('x', 'st', 'zt', opts)
keyset('x', 'sb', 'zb', opts)
keyset('x', 'sm', 'zz', opts)
-- }}}
-- <leader>f -- picker {{{
keyset('n', '<leader>fc', ':CocList commands<cr>', opts)
keyset('x', '<leader>fc', ':<C-U>CocList commands<cr>', opts)

keyset('n', '<leader>fb', ':CocList buffers<cr>', opts)
keyset('n', '<leader>ff', ':CocList --regex --ignore-case files<cr>', opts)
keyset('n', '<leader>fm', ':CocList mru<cr>', opts)
keyset('n', '<leader>fg', ':grep ', opts)
keyset('n', '<leader>fo', ':CocList outline<cr>', opts)
keyset('n', '<leader>fl', ':CocList<cr>', opts)

keyset('n', '<leader>fa', ':CocList diagnostics<cr>', opts)
keyset('n', '<leader>fr', ':CocList CocListResume<cr>', opts)
-- }}}
-- <leader>w -- window {{{
--keyset('n', 'w', '<NOP>', opts)
--keyset('n', 'ww', 'w', opts)

keyset('n', '<leader>wt', '<Plug>(coc-terminal-toggle)', plug_opts)

keyset('n', '<leader>wo', '<c-w>o', opts)

keyset('n', '<leader>wj', '<c-w>j', opts)
keyset('n', '<leader>wh', '<c-w>h', opts)
keyset('n', '<leader>wk', '<c-w>k', opts)
keyset('n', '<leader>wl', '<c-w>l', opts)

keyset('n', '<leader>wq', '<c-w>q', opts)
keyset('n', '<leader>wn', '<c-w>w', opts)
keyset('n', '<leader>wp', '<c-w>W', opts)
keyset('n', '<leader>wc', '<c-w>n', opts)
keyset('n', '<leader>wm', '<c-w>p', opts)
keyset('n', '<leader>wv', '<c-w>v', opts)
keyset('n', '<leader>ws', '<c-w>s', opts)

keyset('n', '<leader>w1', '1<c-w>w',opts)
keyset('n', '<leader>w2', '2<c-w>w',opts)
keyset('n', '<leader>w3', '3<c-w>w',opts)
keyset('n', '<leader>w4', '4<c-w>w',opts)
keyset('n', '<leader>w5', '5<c-w>w',opts)
keyset('n', '<leader>w6', '6<c-w>w',opts)
keyset('n', '<leader>w7', '7<c-w>w',opts)
keyset('n', '<leader>w8', '8<c-w>w',opts)
keyset('n', '<leader>w9', '9<c-w>w',opts)
-- }}}
-- <leader>t -- tab{{{
--keyset('n', 't', '<NOP>', opts)
--keyset('n', 'tt', 't', opts)

keyset('n', '<leader>tn', 'gt', opts)
keyset('n', '<leader>tp', 'gT', opts)
keyset('n', '<leader>tm', 'g<TAB>', opts)
keyset('n', '<leader>tc', '<cmd>tabnew<cr>', opts)
keyset('n', '<leader>tq', '<cmd>tabclose<cr>', opts)
keyset('n', '<leader>t1', '1gt', opts)
keyset('n', '<leader>t2', '2gt', opts)
keyset('n', '<leader>t3', '3gt', opts)
keyset('n', '<leader>t4', '4gt', opts)
keyset('n', '<leader>t5', '5gt', opts)
keyset('n', '<leader>t6', '6gt', opts)
keyset('n', '<leader>t7', '7gt', opts)
keyset('n', '<leader>t8', '8gt', opts)
keyset('n', '<leader>t9', '9gt', opts)
--}}}
-- <leader>b -- buffer{{{
--keyset('n', 'b', '<NOP>', opts)
--keyset('n', 'bb', 'b', opts)

keyset('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
keyset('n', '<leader>bn', '<cmd>bnext<CR>', opts)
keyset('n', '<leader>bd', '<cmd>Bdelete<CR>', opts)
--keyset('n', '<leader>bd', '<cmd>bdelete<CR>', opts)
keyset('n', '<leader>bm', '<c-^>', opts)
--}}}
-- <a-cr> -- send-command {{{
keyset('n', '<a-cr>', '<Plug>(coc-command-send-line)', plug_opts)
keyset('x', '<a-cr>', '<Plug>(coc-command-send-range)', plug_opts)
keyset('i', '<a-cr>', '<c-\\><c-o><Plug>(coc-command-send-line)', plug_opts)
--}}}
-- command line edit {{{
keyset('c', '<c-a>', '<HOME>', opts)
keyset('c', '<c-e>', '<END>', opts)
keyset('c', '<c-b>', '<Left>', opts)
keyset('c', '<c-f>', '<Right>', opts)
keyset('c', '<a-b>', '<S-Left>', opts)
keyset('c', '<a-f>', '<S-Right>', opts)
keyset('c', '<c-d>', '<delete>', opts)
vim.o.cedit="<C-x>"
--}}}
-- emacs style insert mode {{{
keyset('i', '<c-a>', '<HOME>', opts)
keyset('i', '<c-e>', '<END>', opts)
keyset('i', '<c-b>', '<Left>', opts)
keyset('i', '<c-f>', '<Right>', opts)
keyset('i', '<a-b>', '<S-Left>', opts)
keyset('i', '<a-f>', '<S-Right>', opts)

--keyset('i', '<c-k>', '<Right><Esc>C', opts)
--keyset('i', '<c-u>', '<Esc>d^s', opts)
keyset('i', '<c-y>', '<Esc>pa', opts)
keyset('i', '<c-d>', '<delete>', opts)

keyset('i', '<a-x>', '<Esc>:', opts)
keyset('n', '<a-x>', '<Esc>:', opts)

keyset('i', '<c-v>', '<PageDown>', opts)
keyset('i', '<a-v>', '<PageUp>', opts)

opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset('i', '<c-p>', [[coc#pum#visible() ? coc#pum#prev(0) : "\<Up>"]], opts)
keyset('i', '<c-n>', [[coc#pum#visible() ? coc#pum#next(0) : "\<DOWN>"]], opts)

-- }}}
-- telescope {{{
--keyset('n', '<leader>fc', '<cmd>lua require("telescope.builtin").commands()<cr>', opts)
--keyset('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers({ sort_mru=true, cwd_only=true })<cr>', opts)
--keyset('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', opts)
--keyset('n', '<leader>fm', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', opts)
--keyset('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', opts)
--keyset('n', '<leader>fl', '<cmd>lua require("telescope.builtin").builtin()<cr>', opts)
--keyset('n', '<leader>fa', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', opts)
-- }}}
-- v -- visual{{{
--keyset('n', 'v', '<NOP>', opts)
--keyset('n', 'vv', 'v', opts)
--keyset('n', 'vl', '<s-v>', opts)
--keyset('n', 'vc', '<c-v>', opts)

--keyset('x', 'v', '<NOP>', opts)
--keyset('x', 'vv', 'v', opts)
--keyset('x', 'vl', '<s-v>', opts)
--keyset('x', 'vc', '<c-v>', opts)
--}}}
