"set cedit=<C-R>  "open command line window
set cmdheight=1
"set autowrite
"set autowriteall
set clipboard=unnamed
set colorcolumn=+0
set completeopt=menuone,noinsert,noselect
set nocursorline
set fileencodings=utf-8,gbk,ucs-bom,cp936,gb18030,big5,latin1
set foldlevel=99
"set foldlevelstart=0
"set foldmethod=indent
set foldminlines=0
set hidden
set ignorecase
set laststatus=2
set modeline
"set modelines=1
set mouse=a
"set previewheight=8
set shortmess=filnxtToOFc
set smartcase
set splitbelow
set splitright
set statusline=%t%h%w%m%r%=%l,%c%V\ %P
set updatetime=300
set breakindent
set breakindentopt=shift:0
set nolinebreak
set sts=4 ts=4 sw=4 et
"set nu relativenumber

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
"set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" disable substitute live feedback
set inccommand=""
