-- vim: fdm=marker
local keyset = vim.keymap.set

local opts = { noremap = true }
local plug_opts = {}

--keyset('n', 'j', 'gj', opts)
--keyset('n', 'k', 'gk', opts)

keyset('n', '!', ':!', opts)

keyset('n', '<localleader>s', '<cmd>w<CR>', opts)
keyset('n', '<localleader>w', '<Plug>TranslateW', plug_opts)
keyset('x', '<localleader>w', '<Plug>TranslateW', plug_opts)

-- g -- goto{{{
keyset('x', 'g0', '<Plug>(coc-goto-first)', plug_opts)
keyset('n', 'gp', '<cmd>Preview<cr>', opts)

keyset('n', 'gw', '<cmd>HopWordAC<CR>', plug_opts)
keyset('n', 'gb', '<cmd>HopWordBC<CR>', plug_opts)
keyset('n', 'gj', '<cmd>HopLineAC<CR>', plug_opts)
keyset('n', 'gk', '<cmd>HopLineBC<CR>', plug_opts)
keyset('x', 'gw', '<cmd>HopWordAC<CR>', plug_opts)
keyset('x', 'gb', '<cmd>HopWordBC<CR>', plug_opts)
keyset('x', 'gj', '<cmd>HopLineAC<CR>', plug_opts)
keyset('x', 'gk', '<cmd>HopLineBC<CR>', plug_opts)
--keyset('n', 'gj', function()
    --require("flash").jump({
        --search = { mode = "search", max_length = 0 },
        --label = { after = { 0, 0 } },
        --pattern = "^"
    --})
--end, opts)

--keyset('n', 'gw', function()
    --require("flash").jump({
        --search = {
            --mode = function(str)
                --return "\\<" .. str
            --end,
        --},
    --})
--end, opts)


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
-- <leader>w -- window {{{
--keyset('n', 'w', '<NOP>', opts)
--keyset('n', 'ww', 'w', opts)

keyset('n', '<leader>wt', '<Plug>(coc-terminal-toggle)', plug_opts)

keyset('n', '<leader>wo', '<c-w>o', opts)

keyset('n', '<leader>wj', '<c-w>j', opts)
keyset('n', '<leader>wh', '<c-w>h', opts)
keyset('n', '<leader>wk', '<c-w>k', opts)
keyset('n', '<leader>wl', '<c-w>l', opts)

keyset('n', '<leader>wJ', '<c-w>J', opts)
keyset('n', '<leader>wH', '<c-w>H', opts)
keyset('n', '<leader>wK', '<c-w>K', opts)
keyset('n', '<leader>wL', '<c-w>L', opts)

keyset('n', '<leader>wq', '<c-w>q', opts)
keyset('n', '<leader>wn', '<c-w>w', opts)
keyset('n', '<leader>wp', '<c-w>W', opts)
keyset('n', '<leader>wc', '<c-w>n', opts)
keyset('n', '<leader>wm', '<c-w>p', opts)
keyset('n', '<leader>wv', '<c-w>v', opts)
keyset('n', '<leader>ws', '<c-w>s', opts)

keyset('n', '<leader>w1', '1<c-w>w', opts)
keyset('n', '<leader>w2', '2<c-w>w', opts)
keyset('n', '<leader>w3', '3<c-w>w', opts)
keyset('n', '<leader>w4', '4<c-w>w', opts)
keyset('n', '<leader>w5', '5<c-w>w', opts)
keyset('n', '<leader>w6', '6<c-w>w', opts)
keyset('n', '<leader>w7', '7<c-w>w', opts)
keyset('n', '<leader>w8', '8<c-w>w', opts)
keyset('n', '<leader>w9', '9<c-w>w', opts)
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

keyset('n', '<leader>bb', ':CocList buffers<cr>', opts)
keyset('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
keyset('n', '<leader>bn', '<cmd>bnext<CR>', opts)
--keyset('n', '<leader>bd', '<cmd>Bdelete<CR>', opts)
keyset('n', '<leader>bd', '<cmd>bdelete<CR>', opts)
keyset('n', '<leader>bm', '<c-^>', opts)
keyset('n', '<leader>bc', '<cmd>enew<CR>', opts)
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
vim.o.cedit = "<C-x>"
--}}}
-- emacs style insert mode {{{
keyset('i', '<c-a>', '<HOME>', opts)
keyset('i', '<c-e>', '<END>', opts)
keyset('i', '<a-h>', '<S-Left>', opts)
keyset('i', '<a-l>', '<S-Right>', opts)

--keyset('i', '<c-k>', '<Right><Esc>C', opts)
--keyset('i', '<c-u>', '<Esc>d^s', opts)
keyset('i', '<c-y>', '<Esc>pa', opts)
keyset('i', '<c-d>', '<delete>', opts)

keyset('i', '<a-x>', '<Esc>:', opts)
keyset('n', '<a-x>', '<Esc>:', opts)

keyset('i', '<c-v>', '<PageDown>', opts)
keyset('i', '<a-v>', '<PageUp>', opts)
-- }}}
