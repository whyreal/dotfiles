let g:did_load_filetypes = 0
let g:do_filetype_lua = 1

let g:loaded_python3_provider = 0
let g:loaded_python_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

let g:mapleader=","
let g:maplocalleader=" "

call plug#begin()
"call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'chrisbra/unicode.vim'

Plug 'editorconfig/editorconfig-vim'

"tmux
Plug 'roxma/vim-tmux-clipboard'

"k8s
"Plug 'rottencandy/vimkubectl'
"Plug 'andrewstuart/vim-kubernetes'

" git
Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" fzf
"Plug 'junegunn/fzf', {'do': ':call fzf#install()'}
"Plug 'junegunn/fzf.vim', {}

" theme
Plug 'projekt0n/github-nvim-theme'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'rakr/vim-one'
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" syntax
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'neoclide/jsonc.vim'
Plug 'dag/vim-fish'
Plug 'wizicer/vim-jison'
Plug 'wgwoods/vim-systemd-syntax'
Plug 'godlygeek/tabular'
Plug 'pprovost/vim-ps1'
Plug 'chr4/nginx.vim'
Plug 'pearofducks/ansible-vim'

Plug 'nvim-treesitter/nvim-treesitter'

" Translator
Plug 'voldikss/vim-translator', {'frozen': 1}
" 注释
Plug 'scrooloose/nerdcommenter'
" 对齐
Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-surround'

" 输入法切换
" [smartim](https://github.com/ybian/smartim)
" use [macism](https://github.com/laishulu/macism/) as Input Source Manager
	" 其他切换工具切换书输入法后无法正常使用
"Plug 'ybian/smartim', {'frozen':1, 'do': 'cp /usr/local/bin/macism plugin/im-select'}

"coc
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug '~/code/GitHub/coc.nvim/'

Plug '~/code/whyreal/wr-coc-helper/', {'do': 'yarn install --frozen-lockfile'}
Plug '~/code/whyreal/coc-picgo/', {'do': 'yarn install --frozen-lockfile'}
Plug '~/code/whyreal/coc-snippets/', {'do': 'yarn install --frozen-lockfile'}

Plug 'rafcamlet/coc-nvim-lua'
Plug 'euclidianAce/BetterLua.vim'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
"Plug 'mzlogin/vim-markdown-toc'
"Plug 'masukomi/vim-markdown-folding'

Plug 'honza/vim-snippets'
"Plug 'rafamadriz/friendly-snippets'

Plug 'moll/vim-bbye'

" EasyMotion
Plug 'phaazon/hop.nvim'

call plug#end()

"syntax enable
"filetype plugin indent on

au VimEnter * let g:workspace=$PWD

" 根据焦点变化自动保存或读取文件
"au FocusGained,BufEnter * :silent! !
"au FocusLost,WinLeave * :silent! w
