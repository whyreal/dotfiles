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

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap jj <ESC>
nnoremap < <<
nnoremap <C-H> <C-w><
nnoremap <C-J> <C-w>+
nnoremap <C-K> <C-w>-
nnoremap <C-L> <C-w>>
nnoremap <C-n> gt<CR>
nnoremap <C-p> gT<CR>
nnoremap <Leader>fb :FufBuffer<CR>
nnoremap <Leader>ff :FufFile<CR>
nnoremap <Leader>fh :FufHelp<CR>
nnoremap <Leader>fl :FufLine<CR>
nnoremap <Leader>ft :FufTag<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>r :w<CR>
nnoremap <Leader>s :SyntasticToggleMode<CR>
nnoremap <Leader>vm :Voom markdown<CR>
nnoremap <Leader>vn :Voom<CR>
nnoremap <Leader>vv :VoomToggle<CR>
nnoremap <Leader>vw :Voom vimwiki<CR>
nnoremap <leader>wtt <Plug>VimwikiToggleListItem
nnoremap > >>
nnoremap tc :tabnew<CR>
nnoremap tf :NERDTreeFind<CR>
nnoremap tm :NERDTreeMirror<CR>
nnoremap tt :NERDTreeToggle<CR>
vnoremap < <gv
vnoremap > >gv

""""""""""""""""""""""""""""""
" Modules && Module settings " {{{1
""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
let g:vundle_default_git_proto = 'git'

Bundle 'scrooloose/syntastic'
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

Bundle 'vimwiki'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let nested_syntaxes = {
            \    'lang-html': 'html',
            \    'python': 'python',
            \    'lang-sh': 'shell',
            \    'lang--': 'txt',
            \    'javascript': 'javascript'}

let local_wiki = {}
let local_wiki.path = '~/Documents/localwiki/wiki'
let local_wiki.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let local_wiki.template_default = 'default'
let local_wiki.template_ext = '.html'
let local_wiki.nested_syntaxes = nested_syntaxes

let github_wiki = {}
let github_wiki.path = '~/Documents/whyreal.github.com/wiki'
let github_wiki.template_path = '~/Documents/whyreal.github.com/wiki/templates'
let github_wiki.template_default = 'default'
let github_wiki.template_ext = '.html'
let github_wiki.nested_syntaxes = nested_syntaxes

let g:vimwiki_list = [local_wiki, github_wiki]

" reference: http://wiki.ktmud.com/tips/vim/vimwiki-guide.html
let g:vimwiki_camel_case = 0
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
let g:vimwiki_list_ignore_newline = 0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'ervandew/supertab'
"let g:SuperTabDefaultCompletionType = "<c-n>"

Bundle 'VOoM'
Bundle 'vim-scripts/L9'
Bundle 'mattn/zencoding-vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'vim-scripts/The-NERD-tree'
"Bundle 'AutoComplPop'
"Bundle 'fsouza/go.vim'
"Bundle 'nsf/gocode'

"""""""""""
" Options " {{{1
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
set background=light
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

" gui "
"set guioptions-=r
if has('gui')
    colorscheme desert
    set cul
    set guifont=Menlo:h14
    set guioptions-=T
    set guioptions-=R
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
set smarttab
set ignorecase
set hlsearch
set tags=tags;/
set fileencodings+=gbk
" E37 No write since last change
set hidden


filetype plugin on
filetype indent on
syntax on

