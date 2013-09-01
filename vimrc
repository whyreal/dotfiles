" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set backspace=2 " more powerful backspacing

filetype off                   " required!

"""""""
" Map " {{{1
"""""""
let mapleader = ","
"set timeoutlen=500
" <Leader>w used by vimwiki plugin

"nnoremap <C-H> <C-w><
"nnoremap <C-J> <C-w>+
"nnoremap <C-K> <C-w>-
"nnoremap <C-L> <C-w>>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap jj <ESC>
nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

nnoremap <C-n> gt<CR>
nnoremap <C-p> gT<CR>

nnoremap <Leader>fb :FufBuffer<CR>
nnoremap <Leader>ff :FufFile<CR>
nnoremap <Leader>fh :FufHelp<CR>
nnoremap <Leader>fl :FufLine<CR>
nnoremap <Leader>ft :FufTag<CR>

nnoremap <Leader>q :q<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>c :SyntasticToggleMode<CR>

nnoremap <Leader>vn :Voom<CR>
nnoremap <Leader>vm :Voom markdown<CR>
nnoremap <Leader>vv :VoomToggle<CR>
nnoremap <Leader>vw :Voom vimwiki<CR>

nnoremap <Leader>wtt :VimwikiToggleListItem<CR>

nnoremap tc :tabnew<CR>

nnoremap tf :NERDTreeFind<CR>
nnoremap tm :NERDTreeMirror<CR>
nnoremap tt :NERDTreeToggle<CR>


""""""""""""""""""""""""""""""
" Modules && Module settings " {{{1
""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
let g:vundle_default_git_proto = 'git'

Bundle 'scrooloose/syntastic'
"let g:syntastic_mode_map = { 'mode': 'passive'}
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
let g:syntastic_javascript_checker = 'jshint'

let g:syntastic_ruby_checker = 'macruby'

Bundle 'vim-scripts/FuzzyFinder'
let g:fuf_fuzzyRefining = 1

Bundle 'UltiSnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"
let g:UltiSnipsSnippetDirectories = ["snippets", "UltiSnips"]

Bundle 'vimwiki/vimwiki'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let nested_syntaxes = {
            \    'lang-html': 'html',
            \    'python': 'python',
            \    'lang-sh': 'shell',
            \    'lang--': 'txt',
            \    'javascript': 'javascript'}

let xiaomi = {}
let xiaomi.path = '~/Documents/xiaomi_wiki/wiki'
let xiaomi.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let xiaomi.template_default = 'default'
let xiaomi.template_ext = '.html'
let xiaomi.nested_syntaxes = nested_syntaxes

let sina = {}
let sina.path = '~/Documents/sina_wiki/wiki'
let sina.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let sina.template_default = 'default'
let sina.template_ext = '.html'
let sina.nested_syntaxes = nested_syntaxes

let personal = {}
let personal.path = '~/Documents/personal_wiki/wiki'
let personal.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let personal.template_default = 'default'
let personal.template_ext = '.html'
let personal.nested_syntaxes = nested_syntaxes

let github_wiki = {}
let github_wiki.path = '~/Documents/whyreal.github.com/wiki'
let github_wiki.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let github_wiki.template_default = 'default'
let github_wiki.template_ext = '.html'
let github_wiki.nested_syntaxes = nested_syntaxes

let g:vimwiki_list = [xiaomi, personal, github_wiki, sina]

" reference: http://wiki.ktmud.com/tips/vim/vimwiki-guide.html
let g:vimwiki_camel_case = 0
" 对中文用户来说，我们并不怎么需要驼峰英文成为维基词条
let g:vimwiki_camel_case = 0
" 标记为完成的 checklist 项目会有特别的颜色
let g:vimwiki_hl_cb_checked = 1
" 我的 vim 是没有菜单的，加一个 vimwiki 菜单项也没有意义
let g:vimwiki_menu = ''
" 是否开启按语法折叠  会让文件比较慢
"let g:vimwiki_folding = 1
" 是否在计算字串长度时用特别考虑中文字符
"let g:vimwiki_CJK_length = 1

"let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,h1'
let g:vimwiki_valid_html_tags = ''
let g:vimwiki_list_ignore_newline = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Bundle 'ervandew/supertab'
"let g:SuperTabDefaultCompletionType = "<c-n>"

Bundle 'vim-scripts/The-NERD-tree'
let g:NERDTreeShowBookmarks = 1

Bundle 'VOoM'
Bundle 'mattn/zencoding-vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'vim-scripts/L9'
Bundle 'nginx.vim'
Bundle 'fsouza/go.vim'
Bundle 'Command-T'
"Bundle 'snipMate'
"Bundle 'AutoComplPop'
"Bundle 'leafo/moonscript-vim'
"Bundle 'vim-scripts/Colour-Sampler-Pack'
"Bundle 'nsf/gocode'
"Bundle 'eclim'
"let g:EclimJavaCompleteCaseSensitive=1

"""""""""""
" Options " {{{1
"""""""""""
set pastetoggle=<F11>         " 粘贴开关
set clipboard=unnamed         " yank and paste with the system clipboard
set autoread

" fold
set foldmethod=indent
set foldlevelstart=99
set fillchars=vert:\|,fold:\ 

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
"set smartindent
set expandtab
"set textwidth=80
set colorcolumn=80       " highlight column after 'textwidth'
"set list listchars=tab:\¦\ ,trail:·
set list listchars=tab:»\ ,trail:·
set laststatus=2
set statusline=%y\ %m%F%=%r\ line:\ %l\ column:\ %c\ %P

" performance "
"set synmaxcol=200
"set lazyredraw
set scrolljump=5
set scrolloff=5
set mouse=a
colorscheme solarized
set t_Co=256

" gui "
"set guioptions-=r
if has('gui')
    "colorscheme codeschool
    set cul
    set guifont=Menlo:h12
    set guioptions-=T
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
set tags=tags;/
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
" E37 No write since last change
set hidden

filetype plugin on
filetype indent on
syntax on
