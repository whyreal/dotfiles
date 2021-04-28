let g:mapleader=","
let g:maplocalleader=" "

call plug#begin()
"call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'

Plug 'junegunn/fzf', {'do': ':call fzf#install()'}
Plug 'junegunn/fzf.vim', {}

Plug 'NLKNguyen/papercolor-theme', {'frozen': 1}
Plug 'challenger-deep-theme/vim', {'frozen': 1}
Plug 'altercation/vim-colors-solarized', {'frozen': 1}
Plug 'Glench/Vim-Jinja2-Syntax', {'frozen': 1}
Plug 'neoclide/jsonc.vim', {'frozen': 1}
Plug 'dag/vim-fish', {'frozen': 1}
" markdown
Plug 'plasticboy/vim-markdown', {'frozen': 1}

" Translator
Plug 'voldikss/vim-translator', {'frozen': 1}

" 注释
Plug 'scrooloose/nerdcommenter', {'frozen': 1}
" outline
"Plug 'vim-voom/VOoM', {'frozen': 1}
Plug 'preservim/tagbar', {'frozen': 1, 'do': ':lua tagbar()'}
" 对齐
Plug 'junegunn/vim-easy-align', {'frozen': 1}

Plug 'tpope/vim-surround', {'frozen': 1}

"coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Plug 'kyazdani42/nvim-web-devicons', {'frozen': 1}
"lsp
"Plug 'nvim-lua/completion-nvim'
"Plug 'neovim/nvim-lspconfig'
"treesitter
"Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'nvim-treesitter/completion-treesitter'
"vsnip
"Plug 'rafamadriz/friendly-snippets'
"Plug 'hrsh7th/vim-vsnip-integ'
"Plug 'hrsh7th/vim-vsnip',

" insert mode auto-completion for quotes, parens, brackets, etc.
"Plug 'Raimondi/delimitMate', {'frozen': 1}

" 输入法切换
" [smartim](https://github.com/ybian/smartim)
" use [macism](https://github.com/laishulu/macism/) as Input Source Manager
	" 其他切换工具切换书输入法后无法正常使用
"Plug 'ybian/smartim', {'frozen':1, 'do': 'cp /usr/local/bin/macism plugin/im-select'}
" rest client
"Plug 'diepm/vim-rest-console'

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

call plug#end()

syntax on
filetype plugin indent on

lua require("GInit")

au VimEnter * let g:workspace=$PWD

