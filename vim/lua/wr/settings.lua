----------------
-- option
----------------
vim.g.mapleader = ","
vim.g.maplocalleader = " "

vim.g.loaded_node_provider    = 0
vim.g.loaded_python_provider  = 0
--vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.netrw_winsize = 30
-- 0 keep the current directory the same as the browsing directory.
-- let g:netrw_keepdir=0
vim.g.netrw_bookmarklist = "[$PWD]"

vim.o.laststatus    = 2
vim.o.cursorline    = false
vim.o.clipboard     = "unnamed"
vim.o.foldlevel     = 99
vim.o.fileencodings = "utf-8,gbk,ucs-bom,cp936,gb18030,big5,latin1"
vim.o.modeline      = true
vim.o.modelines     = 3
vim.o.smartcase     = true
vim.o.ignorecase    = true
vim.o.mouse         = "a"
--vim.o.cmdheight     = 2
vim.o.autowrite     = true
--vim.o.background    = 'dark'
vim.o.background  = 'light'
vim.o.colorcolumn   = '+0'
vim.o.previewheight = 8
vim.o.splitbelow    = true
vim.o.hidden        = true
vim.o.updatetime    = 300
vim.o.completeopt   = "menuone,noinsert,noselect"
vim.o.shortmess     = "filnxtToOFc"
vim.o.cedit         = "<C-R>"  -- open command line window
vim.o.statusline="%t %h%w%m%r %=%(%l,%c%V %= %P%)"
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.breakindentopt = 'shift:0'

----------------
-- map
----------------
-- map <c-n> <c-p> 后，补全菜单不会自动 insert 体验很差
--vim.api.nvim_set_keymap('i', '<c-n>',      '<Down>',                      { noremap = false, silent = false })
--vim.api.nvim_set_keymap('i', '<c-p>',      '<Up>',                        { noremap = false, silent = false })
wr.map('i', '<c-a>',      '<Home>' )
wr.map('i', '<c-e>',      '<End>' )
wr.map('i', '<c-f>',      '<Right>' )
wr.map('i', '<c-b>',      '<Left>' )
wr.map('i', '<c-k>',      '<c-o>D' )
wr.map('i', 'jj',      '<ESC>' )

wr.map('n', 'j',          'gj' )
wr.map('n', 'k',          'gk' )

wr.mapcmd('n', '<leader>bp', 'bprevious' )
wr.mapcmd('n', '<leader>bn', 'bnext' )
wr.mapcmd('n', '<leader>bd', 'bd' )
wr.mapcmd('n', '<leader>bw', 'bw' )
wr.mapcmd('n', '<leader>w',  'w' )
wr.mapcmd('n', '<a-=>',      'split term://$SHELL' )
wr.map('n', '<leader>bo', '<c-^>' )

wr.mapcmd('n', '<leader>ve', 'Explore' )
wr.map('t', '<c-o>',      '<c-\\><c-n>' )

wr.maplua('n', '0',          "wr.toggle_home_zero()" )
--vim.api.nvim_set_keymap('n', 'o',          ':lua add_blank_line_after()<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', 'O',          ':lua add_blank_line_before()<CR>', { noremap = true, silent = true })

wr.map('n', '<a-1>',  '1gt' )
wr.map('n', '<a-2>',  '2gt' )
wr.map('n', '<a-3>',  '3gt' )
wr.map('n', '<a-4>',  '4gt' )
wr.map('n', '<a-5>',  '5gt' )
----------------
-- autocmd
----------------
wr.autocmd('FileType go setlocal ts=4 sw=4')
wr.autocmd('FileType python,yaml,lua,sh,vim setlocal ts=4 sw=4')
wr.autocmd('FileType java,c,cpp setlocal ts=4 sw=4 et')
wr.autocmd('FileType nginx setlocal ts=4 sw=4')
wr.autocmd('FileType snippets setlocal ts=4 sw=4')
wr.autocmd('FileType jsp,xml,html,css setlocal ts=2 sw=2')
wr.autocmd('FileType javascript,typescript.tsx,json setlocal ts=2 sw=2')
wr.autocmd('FileType help nmap <buffer> <c-]> <c-]>')

wr.autocmd('BufNewFile,BufRead *.json setlocal filetype=jsonc ts=2 sw=2')
wr.autocmd('BufNewFile,BufRead *.tsx set filetype=typescript.tsx')
wr.autocmd('BufNewFile,BufRead *.jsx set filetype=javascript.jsx')
wr.autocmd('BufNewFile,BufRead *.docker set filetype=Dockerfile')

wr.autocmd('BufEnter * if &filetype == "" | setlocal ft=text | endif')

---------------------
-- Command
---------------------
vim.cmd('filetype plugin indent on')
vim.cmd('colorscheme onehalflight')

wr.new_cmd('VimrcEdit', 'tabe ~/.config/nvim/init.vim')
wr.new_cmd('Dos2unix', 'e ++ff=unix | %s/\r//g')
vim.cmd('syntax on')

if vim.env.tmux_version ~= nil then
	vim.o.termguicolors = true
	vim.cmd[[highlight Normal guibg=NONE]]
end

-- Sshconfig
wr.new_cmd('Sshconfig', 'tabe ~/Documents/Note/scripts/ssh.config.json')
wr.autocmd('BufWritePost ~/Documents/Note/scripts/ssh.config.json !update_ssh_config.sh')
-- shadowsocks config
wr.new_cmd('Ssconfig', 'tabe ~/.ShadowsocksX/user-rule.txt')
wr.autocmd('BufWritePost ~/.ShadowsocksX/user-rule.txt !update_ss_config.sh')

wr.new_cmd("-range TemplateRender", "call luaeval('wr.template_render(unpack(_A))', [<line1>, <line2>])")
wr.new_cmd("-range TemplateSet", "call luaeval('wr.template_set(unpack(_A))', [<line1>, <line2>])")

wr.new_cmd("Reveals", " !open -R %:S")
wr.new_cmd("Code", "!open -a \"Visual Studio Code.app\" %:S")

wr.new_cmd("Docs", "cd /Users/Real/Documents/vim-workspace/docs")

-- command! -nargs=1 Edit lua edit_remote_file(<f-args>)
-- command! ServerUpdateInfo lua update_server_info()
