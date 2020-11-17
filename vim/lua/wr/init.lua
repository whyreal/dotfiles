require('wr.utils')

vim.g.loaded_node_provider    = 0
vim.g.loaded_python_provider  = 0
--vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0

--if vim.fn.has('nvim') == 1 then
    ---- do something...
--end

----------------
-- option
----------------
vim.g.mapleader = ","

vim.o.cursorline    = true
vim.o.clipboard     = "unnamed"
vim.o.foldlevel     = 99
vim.o.fileencodings = "utf-8,gbk,ucs-bom,cp936,gb18030,big5,latin1"
vim.o.modeline      = true
vim.o.modelines     = 3
vim.o.smartcase     = true
vim.o.ignorecase    = true
vim.o.mouse         = "a"
vim.o.cmdheight     = 2
vim.o.autowrite     = true
vim.o.background    = 'dark'
--vim.o.background    = 'light'
vim.o.colorcolumn   = '+1'
vim.o.previewheight = 8
vim.o.splitbelow    = true
vim.o.hidden        = true
vim.o.updatetime = 300
vim.o.completeopt="menuone,noinsert,noselect"
vim.o.shortmess = "filnxtToOFc"
vim.o.cedit = "<C-R>"  -- open command line window

----------------
-- map
----------------
vim.api.nvim_set_keymap('!', '<c-a>',      '<Home>',                      { noremap = true, silent = false })
vim.api.nvim_set_keymap('!', '<c-e>',      '<End>',                       { noremap = true, silent = false })
vim.api.nvim_set_keymap('!', '<c-f>',      '<Right>',                     { noremap = true, silent = false })
vim.api.nvim_set_keymap('!', '<c-b>',      '<Left>',                      { noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<c-k>',      '<c-o>D',                      { noremap = true, silent = false })
-- map <c-n> <c-p> 后，补全菜单不会 insert 体验很差
--vim.api.nvim_set_keymap('i', '<c-n>',      '<Down>',                      { noremap = false, silent = false })
--vim.api.nvim_set_keymap('i', '<c-p>',      '<Up>',                        { noremap = false, silent = false })

vim.api.nvim_set_keymap('n', 'j',          'gj',                          { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'k',          'gk',                          { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>',              { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>',                  { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>',                     { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', '<leader>w',  ':w<CR>',                      { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>ve', ':Explore<CR>',                { noremap = true, silent = false })
vim.api.nvim_set_keymap('t', '<c-o>',      '<c-\\><c-n>',                 { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<a-=>',      ':split term://$SHELL<CR>',    { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', '0',          ":lua require'wr.utils'.toggle_home_zero()<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'o',          ':lua add_blank_line_after()<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'O',          ':lua add_blank_line_before()<CR>', { noremap = true, silent = true })

----------------
-- autocmd
----------------
vim.api.nvim_command('autocmd FileType go setlocal ts=4 sw=4')
vim.api.nvim_command('autocmd FileType python,yaml,lua,sh,vim setlocal ts=4 sw=4')
vim.api.nvim_command('autocmd FileType markdown setlocal ts=4 sw=4 et')
vim.api.nvim_command('autocmd FileType markdown let g:tagbar_sort = 0')
vim.api.nvim_command('autocmd FileType java,c,cpp setlocal ts=4 sw=4 et')
vim.api.nvim_command('autocmd FileType nginx setlocal ts=4 sw=4')
vim.api.nvim_command('autocmd FileType snippets setlocal ts=4 sw=4')
vim.api.nvim_command('autocmd FileType jsp,xml,html,css setlocal ts=2 sw=2')
vim.api.nvim_command('autocmd FileType javascript,typescript.tsx,json setlocal ts=2 sw=2')
vim.api.nvim_command('autocmd FileType help nmap <buffer> <c-]> <c-]>')

vim.api.nvim_command('autocmd BufNewFile,BufRead *.json setlocal filetype=jsonc ts=2 sw=2')
vim.api.nvim_command('autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx')
vim.api.nvim_command('autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx')
vim.api.nvim_command('autocmd BufNewFile,BufRead *.docker set filetype=Dockerfile')

vim.api.nvim_command('autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif')

---------------------
-- Command
---------------------
vim.api.nvim_command('filetype plugin indent on')
vim.api.nvim_command('colorscheme PaperColor')
vim.api.nvim_command('command! VimrcEdit tabe ~/.config/nvim/init.vim')
vim.api.nvim_command('command! Dos2unix e ++ff=unix | %s/\r//g')
vim.api.nvim_command('syntax on')

-- Sshconfig
vim.api.nvim_command('command! Sshconfig tabe ~/Documents/Note/scripts/ssh.config.json')
vim.api.nvim_command('au BufWritePost ~/Documents/Note/scripts/ssh.config.json !update_ssh_config.sh')
-- shadowsocks config
vim.api.nvim_command('command! Ssconfig tabe ~/.ShadowsocksX/user-rule.txt')
vim.api.nvim_command('au BufWritePost ~/.ShadowsocksX/user-rule.txt !update_ss_config.sh')
