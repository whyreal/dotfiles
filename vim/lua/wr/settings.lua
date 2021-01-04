local utils = require('wr.utils')

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
--vim.o.cedit         = "<C-R>"  -- open command line window
vim.o.statusline="%t %h%w%m%r %=%(%l,%c%V %= %P%)"
--vim.wo.linebreak = true
--vim.wo.breakindent = true
--vim.wo.breakindentopt = 'shift:0'

----------------
-- map
----------------
utils.map('i', 'jj',      '<ESC>' )

utils.map('n', 'j',          'gj' )
utils.map('n', 'k',          'gk' )

utils.mapcmd('n', '<leader>bp', 'bprevious' )
utils.mapcmd('n', '<leader>bn', 'bnext' )
utils.mapcmd('n', '<leader>bd', 'bw' )
utils.mapcmd('n', '<leader>w',  'w' )
utils.mapcmd('n', '<a-=>',      'split term://$SHELL' )
utils.map('n', '<leader>bo', '<c-^>' )

utils.mapcmd('n', '<leader>ve', 'Explore' )
utils.map('t', '<c-o>',      '<c-\\><c-n>' )

utils.maplua('n', '0', "require[[wr.utils]].toggle_home_zero()")

----------------
-- autocmd
----------------
utils.autocmd('FileType go setlocal ts=4 sw=4')
utils.autocmd('FileType python,yaml,lua,sh,vim setlocal ts=4 sw=4')
utils.autocmd('FileType java,c,cpp setlocal ts=4 sw=4 et')
utils.autocmd('FileType nginx setlocal ts=4 sw=4')
utils.autocmd('FileType snippets setlocal ts=4 sw=4')
utils.autocmd('FileType jsp,xml,html,css setlocal ts=2 sw=2')
utils.autocmd('FileType javascript,typescript.tsx,json setlocal ts=2 sw=2')
utils.autocmd('FileType help nmap <buffer> <c-]> <c-]>')

utils.autocmd('BufNewFile,BufRead *.json setlocal filetype=jsonc ts=2 sw=2')
utils.autocmd('BufNewFile,BufRead *.tsx set filetype=typescript.tsx')
utils.autocmd('BufNewFile,BufRead *.jsx set filetype=javascript.jsx')
utils.autocmd('BufNewFile,BufRead *.docker set filetype=Dockerfile')

utils.autocmd('BufEnter * if &filetype == "" | setlocal ft=text | endif')

---------------------
-- Command
---------------------
vim.cmd('filetype plugin indent on')

if vim.fn.has('gui_vimr') == 1 then
	vim.cmd('colorscheme onehalflight')
else
	vim.cmd('colorscheme onehalflight')
end

if vim.env.tmux_version ~= nil then
	vim.o.termguicolors = true
	vim.cmd[[highlight Normal guibg=NONE]]
end

vim.cmd('syntax on')

utils.new_cmd('VimrcEdit', 'tabe ~/.config/nvim/init.vim')
utils.new_cmd('Dos2unix', 'e ++ff=unix | %s/\r//g')
-- Sshconfig
utils.new_cmd('Sshconfig', 'tabe ~/Documents/Note/scripts/ssh.config.json')
utils.autocmd('BufWritePost ~/Documents/Note/scripts/ssh.config.json !update_ssh_config.sh')

-- shadowsocks config
utils.new_cmd('Ssconfig', 'tabe ~/.ShadowsocksX/user-rule.txt')
utils.autocmd('BufWritePost ~/.ShadowsocksX/user-rule.txt !update_ss_config.sh')

-- Template
utils.new_cmd("-range TemplateSet", "lua require[[wr.Range]]:newFromVisual():set_tmpl()")
utils.new_cmd("-range TemplateRender", "lua require[[wr.Range]]:newFromVisual():render_tmpl()")

utils.new_cmd("Reveals", " !open -R %:S")
utils.new_cmd("Code", "!open -a \"Visual Studio Code.app\" %:S")

utils.new_cmd("Docs", "cd /Users/Real/Documents/vim-workspace/docs")

-- edit joplin note with id
vim.cmd('command! -nargs=? JEdit call luaeval("require[[wr.utils]].edit_joplin_note(_A)", <q-args>)')

-- NOTE
-- download html to markdown
vim.cmd('command! -nargs=1 MarkdownDownload call luaeval("require[[wr.utils]].markdown_download(_A)", <q-args>)')
vim.cmd('command! -nargs=0 MarkdownUnescape lua require[[wr.utils]].markdown_unescape()')
