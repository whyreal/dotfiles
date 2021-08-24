let g:mapleader=","
let g:maplocalleader=" "

call plug#begin()
"call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'

"k8s
"Plug 'rottencandy/vimkubectl'
"Plug 'andrewstuart/vim-kubernetes'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" fzf
"Plug 'junegunn/fzf', {'do': ':call fzf#install()'}
"Plug 'junegunn/fzf.vim', {}

Plug 'NLKNguyen/papercolor-theme', {'frozen': 1}
Plug 'challenger-deep-theme/vim', {'frozen': 1}
Plug 'altercation/vim-colors-solarized', {'frozen': 1}

Plug 'Glench/Vim-Jinja2-Syntax', {'frozen': 1}
Plug 'neoclide/jsonc.vim', {'frozen': 1}
Plug 'dag/vim-fish', {'frozen': 1}
Plug 'wizicer/vim-jison', {'frozen': 1}
Plug 'wgwoods/vim-systemd-syntax', {'frozen': 1}
Plug 'plasticboy/vim-markdown', {'frozen': 1}
Plug 'pprovost/vim-ps1', {'frozen': 1}

Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate' }

" Translator
Plug 'voldikss/vim-translator', {'frozen': 1}

" 注释
Plug 'scrooloose/nerdcommenter', {'frozen': 1}
" 对齐
Plug 'junegunn/vim-easy-align', {'frozen': 1}

Plug 'tpope/vim-surround', {'frozen': 1}

" 输入法切换
" [smartim](https://github.com/ybian/smartim)
" use [macism](https://github.com/laishulu/macism/) as Input Source Manager
	" 其他切换工具切换书输入法后无法正常使用
"Plug 'ybian/smartim', {'frozen':1, 'do': 'cp /usr/local/bin/macism plugin/im-select'}

"coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

syntax on
filetype plugin indent on

lua require("GInit")

au VimEnter * let g:workspace=$PWD

" 根据焦点变化自动保存或读取文件
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

lua <<EOF
require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {},  -- list of language that will be disabled
    },
}
EOF
