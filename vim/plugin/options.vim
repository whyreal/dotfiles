if has('gui_vimr')
lua <<EOF
package.path = HOME .. "/.luarocks/share/lua/5.1/?.lua;"
			 .. HOME .. "/.luarocks/share/lua/5.1/?/init.lua;"
			 .. package.path
package.cpath = HOME .. "/.luarocks/lib/lua/5.1/?.so;" .. package.cpath
EOF
end

let g:loaded_node_provider=0
let g:loaded_python_provider=0
"let g:loaded_python3_provider=0
let g:loaded_ruby_provider=0
let g:loaded_perl_provider=0
let g:ft_man_folding_enable=1

"set cedit=<C-R>  "open command line window
"set cmdheight=2
set autowrite
set background=light
"set background=dark
set clipboard=unnamed
set colorcolumn=+0
set completeopt=menuone,noinsert,noselect
set cursorline
set fileencodings=utf-8,gbk,ucs-bom,cp936,gb18030,big5,latin1
set foldclose=all
set foldlevel=0
set foldlevelstart=0
set foldmethod=indent
set hidden
set ignorecase
set laststatus=2
set modeline
set modelines=1
set mouse=a
set previewheight=8
set shortmess=filnxtToOFc
set smartcase
set splitbelow
set statusline=%t%h%w%m%r%=%(%l,%c%V%=%P%)
set updatetime=300
set breakindent
set breakindentopt=shift:0
set nolinebreak
set sts=4 ts=4 sw=4 et

if has("gui_vimr")
   colorscheme PaperColor
else
   colorscheme PaperColor
endif

if getenv("tmux_version") != v:null
   set termguicolors
   highlight Normal guibg=NONE
endif
