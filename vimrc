" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set backspace=2 " more powerful backspacing

filetype off                   " required!

"""""""
" Map " {{{1
" 一些按键绑定, 关于这部分可以:help map.txt
"""""""
"set timeoutlen=500

"惯用法
let mapleader = ","

"快捷调整窗口大小
"nnoremap <C-H> <C-w><
"nnoremap <C-J> <C-w>+
"nnoremap <C-K> <C-w>-
"nnoremap <C-L> <C-w>>

" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

"插入模式下移动光标
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"插入模式下按jj进入一般模式, 但是输入j时会有明显的延迟, 惯用法, 也有人用jk. 看习惯吧.
inoremap jj <ESC> 

"gv用来选中上次选中的内容, 这条map可以快速调整块缩进
vnoremap < <gv
vnoremap > >gv

"切换标签
nnoremap <C-n> gt<CR>
nnoremap <C-p> gT<CR>

nnoremap < <<
nnoremap > >>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>w :w<CR>

" Close the current buffer
map <leader>c :Bclose<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

""""""""""""""""""""""""""""""
" Modules && Module settings " {{{1
" 模块的的help 在:help的最下面
""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"vim 插件管理系统
Bundle 'gmarik/vundle'
let g:vundle_default_git_proto = 'git'

"静态语法检查插件, 支持常见语言
Bundle 'scrooloose/syntastic'
nnoremap <Leader>c :SyntasticToggleMode<CR>
"let g:syntastic_mode_map = { 'mode': 'passive'}
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
let g:syntastic_javascript_checker = 'jshint'

"查找buffer, file, help等 
Bundle 'vim-scripts/FuzzyFinder'
let g:fuf_fuzzyRefining = 1
nnoremap <Leader>fb :FufBuffer<CR> "
nnoremap <Leader>ff :FufFile<CR>
nnoremap <Leader>fh :FufHelp<CR>
nnoremap <Leader>fl :FufLine<CR>
nnoremap <Leader>ft :FufTag<CR>

"提供类似于textmate bundle的高级代码补全功能, 比snippets强大
Bundle 'UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"
let g:UltiSnipsSnippetDirectories = ["snippets", "UltiSnips"]

"文件系统导航插件
Bundle 'vim-scripts/The-NERD-tree'
nnoremap <Leader>ntf :NERDTreeFind<CR>
nnoremap <Leader>ntm :NERDTreeMirror<CR>
nnoremap <Leader>ntt :NERDTreeToggle<CR>
let g:NERDTreeShowBookmarks = 1

"markdown 语法高亮插件
Bundle 'Markdown'
Bundle 'instant-markdown.vim'

"文件内导航插件, 支持wiki, markdown等多种格式, 同时支持自定义
Bundle 'VOoM'
nnoremap <Leader>vn :Voom<CR>
nnoremap <Leader>vm :Voom markdown<CR>
nnoremap <Leader>vv :VoomToggle<CR>
nnoremap <Leader>vw :Voom vimwiki<CR>

"基础函数库, 一些插件依赖该插件, 比如UltiSnips
Bundle 'vim-scripts/L9'

" origin zencoding
Bundle 'vim-scripts/Emmet.vim'

"
Bundle "kakkyz81/evervim"
source ~/.vim_evernot_developer_token

" dash
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'
nmap <silent> <leader>d <Plug>DashSearch
let g:dash_map = {
    \ 'python'     : 'py',
    \ }

"""""""""""
" Options " {{{1
"""""""""""
set pastetoggle=<F11>         " 粘贴开关
set clipboard=unnamed         " yank and paste with the system clipboard
set autoread

" fold
set fillchars=vert:\|,fold:\ 
set nofoldenable  "默认不折叠代码
set foldmethod=indent

" 命令行补全
set wildmenu
set wildmode=full

" view "
set nu "显示行号
set background=dark  "设置背景色, 某些theme会根据背景色的不同有不同的显示效果
"set fdc=4
set tabstop=4
set shiftwidth=4
set autoindent       "自动缩进
"set smartindent
set expandtab        "用空格替换tab, 有效防止python代码中tab/space混用的问题
"set textwidth=80
set colorcolumn=80       " highlight column after 'textwidth'
"set list listchars=tab:\¦\ ,trail:·
set list listchars=tab:»\ ,trail:·
set laststatus=2
set statusline=%y\ %m%F%=%r\ line:\ %l\ column:\ %c\ %P

" performance  mac自带的terminal性能貌似有些问题, 推荐使用iterm2
set synmaxcol=200
set scrolljump=5
set scrolloff=5
set ttyfast " u got a fast terminal
set ttyscroll=3
"set lazyredraw " to avoid scrolling problems
"set mouse=a

colorscheme codeschool
set t_Co=256     "mac 上在tmux中打开vim该选项有异常, 可能导致色彩显示异常

" gui "
"set guioptions-=r
if has('gui')
    set cul
    set mouse=a
    set guifont=Menlo:h14
    set guioptions-=T  "关闭菜单, 滚动条等UI元素
    set guioptions-=R
    set guioptions-=r
    set guioptions-=l
    set guioptions-=L
endif

""""""""
" Misc " {{{1
""""""""
set modeline
set modelines=5
set autochdir
set smartcase
"set smarttab
set ignorecase
set hlsearch
set incsearch
set tags=tags;/  "从打开文件所在的目录, 逐级目录向上查找tags文件. 通常在项目的根目录生成tags文件即可
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
" E37 No write since last change
set hidden

filetype plugin on
filetype indent on
syntax on

au BufNewFile,BufRead *.pp setfiletype ruby

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
