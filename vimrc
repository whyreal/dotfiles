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

Bundle 'gmarik/vundle'
let g:vundle_default_git_proto = 'git'

Bundle 'scrooloose/syntastic'
"let g:syntastic_javascript_jslint_conf = "--nomen --white"
let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
let g:syntastic_mode_map = { 'mode': 'passive'}
let g:syntastic_javascript_checker = 'jshint'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

Bundle 'vim-scripts/FuzzyFinder'
let g:fuf_fuzzyRefining = 1

Bundle 'UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"
let g:UltiSnipsSnippetDirectories = ["snipts", "UltiSnips"]

Bundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"

Bundle 'vim-scripts/The-NERD-tree'
let g:NERDTreeShowBookmarks=1

Bundle 'vimwiki'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" reference: http://wiki.ktmud.com/tips/vim/vimwiki-guide.html
let g:vimwiki_camel_case = 0
let g:vimwiki_list = [
\   {
\       'path': '~/Documents/whyreal.github.com/wiki',
\       'path_html': '~/Documents/whyreal.github.com/',
\       'template_path': '~/Documents/whyreal.github.com/wiki/templates',
\       'template_ext': '.tpl'
\   },{
\       'path': '~/Documents/localwiki/wiki',
\       'path_html': '~/Documents/localwiki/',
\       'template_path': '~/Documents/whyreal.github.com/wiki/templates',
\       'template_ext': '.tpl'
\   }
\]
" 对中文用户来说，我们并不怎么需要驼峰英文成为维基词条
let g:vimwiki_camel_case = 0
" 标记为完成的 checklist 项目会有特别的颜色
let g:vimwiki_hl_cb_checked = 1
" 我的 vim 是没有菜单的，加一个 vimwiki 菜单项也没有意义
"let g:vimwiki_menu = ''
" 是否开启按语法折叠  会让文件比较慢
"let g:vimwiki_folding = 1
" 是否在计算字串长度时用特别考虑中文字符
"let g:vimwiki_CJK_length = 1

"let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,h1'
let g:vimwiki_valid_html_tags = ''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'VOoM'
Bundle 'vim-scripts/L9'
Bundle 'Colortest'
Bundle 'mattn/zencoding-vim'
Bundle 'AutoComplPop'
Bundle 'fsouza/go.vim'
Bundle 'nsf/gocode'
Bundle 'plasticboy/vim-markdown'

filetype plugin on
filetype indent on
syntax on

"""""""
" Map "
"""""""
let mapleader = ","
"set timeoutlen=500
nmap <Leader>c :SyntasticToggleMode<CR>
nmap <Leader>fb :FufBuffer<CR>
nmap <Leader>ff :FufFile<CR>
nmap <Leader>ft :FufTag<CR>
nmap <Leader>q :q<CR>
nmap <Leader>s :w<CR>
nmap <Leader>v :VoomToggle<CR>
nmap <Leader>vm :Voom markdown<CR>
nmap <Leader>vn :Voom<CR>
nmap <Leader>vw :Voom vimwiki<CR>

nmap tp :tabprevious<CR>
nmap tn :tabnext<CR>
nmap tc :tabnew<CR>
nmap tt :NERDTreeToggle<CR>
nmap tf :NERDTreeFind<CR>
nmap tm :NERDTreeMirror<CR>
"nmap <Leader>l :FufLine<CR>

inoremap jj <ESC>
vnoremap > >gv
vnoremap < <gv
nmap > >>
nmap < <<
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
set background=dark
"set fdc=4
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
set textwidth=80
set colorcolumn=81       " highlight column after 'textwidth'
"set list listchars=tab:\¦\ ,trail:·
set list listchars=tab:»\ ,trail:·
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
    colorscheme desert
    set cul
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
"set ignorecase
set hlsearch
set tags=tags;/
set fileencodings+=gbk
" E37 No write since last change
set hidden
