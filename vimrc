" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

""""""""""""""""""""""""""""""
" Modules && Module settings "
""""""""""""""""""""""""""""""
let mapleader = ","

Bundle 'gmarik/vundle'
let g:vundle_default_git_proto = 'git'

Bundle 'scrooloose/syntastic'
"let g:syntastic_javascript_jslint_conf = "--nomen --white"
let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
let g:syntastic_mode_map = { 'mode': 'passive'}
let g:syntastic_javascript_checker = 'jshint'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
nmap <Leader>s :SyntasticToggleMode<CR>

Bundle 'vim-scripts/FuzzyFinder'
let g:fuf_fuzzyRefining = 1
nmap <Leader>b :FufBuffer<CR>
nmap <Leader>f :FufFile<CR>
nmap <Leader>l :FufLine<CR>
nmap <Leader>t :FufTag<CR>

Bundle 'UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"
let g:UltiSnipsSnippetDirectories = ["snipts", "UltiSnips"]

Bundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"

Bundle 'vim-scripts/The-NERD-tree'
nmap tt :NERDTreeToggle<CR>
nmap tf :NERDTreeFind<CR>
nmap tm :NERDTreeMirror<CR>

Bundle 'vim-scripts/L9'
Bundle 'Colortest'
Bundle 'vim-scripts/Markdown'
Bundle 'mattn/zencoding-vim'
Bundle 'AutoComplPop'
Bundle 'fsouza/go.vim'

filetype plugin on
filetype indent on
syntax on

"""""""
" Map "
"""""""
set timeoutlen=500
nmap <Leader>q :q<CR>
nmap <Leader>w :w<CR>
inoremap jj <ESC>
nmap tp :tabprevious<CR>
nmap tn :tabnext<CR>
nmap tc :tabnew<CR>
vnoremap > >gv
vnoremap < <gv
nmap <C-J> <C-w>+
nmap <C-K> <C-w>-
nmap <C-H> <C-w><
nmap <C-L> <C-w>>

"""""""""""
" options "
"""""""""""
" 粘贴开关
set pastetoggle=<F11>

" fold
set foldmethod=indent
set foldlevelstart=99
set fillchars=vert:\ ,fold:\ 

" 命令行补全
set wildmenu
set wildmode=full

" view "
"set nu
set cul
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
set textwidth=80
set colorcolumn=80       " highlight column after 'textwidth'
set list listchars=tab:\¦\ ,trail:·
"set list listchars=tab:»\ ,trail:·
set laststatus=2
set statusline=%y\ %m%F%=%r\ line:\ %l\ column:\ %c\ %P

" performance "
"set synmaxcol=200
set lazyredraw
set scrolljump=5
set scrolloff=5

" gui "
"set guioptions-=r
if has('gui')
    colorscheme ir_black
    set guifont=Menlo\ Regular:h14
    set guioptions-=T
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set linespace=0
endif

""""""""
" Misc "
""""""""
set modeline
set modelines=5
set autochdir
set smartcase
set ignorecase
set hlsearch
set tags=tags;/
set fileencodings+=gbk
" E37 No write since last change
set hidden
