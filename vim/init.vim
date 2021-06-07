let g:mapleader=","
let g:maplocalleader=" "

call plug#begin()
"call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" fzf
Plug 'junegunn/fzf', {'do': ':call fzf#install()'}
Plug 'junegunn/fzf.vim', {}

Plug 'NLKNguyen/papercolor-theme', {'frozen': 1}
Plug 'challenger-deep-theme/vim', {'frozen': 1}
Plug 'altercation/vim-colors-solarized', {'frozen': 1}
Plug 'Glench/Vim-Jinja2-Syntax', {'frozen': 1}
Plug 'neoclide/jsonc.vim', {'frozen': 1}
Plug 'dag/vim-fish', {'frozen': 1}
Plug 'wizicer/vim-jison', {'frozen': 1}
Plug 'wgwoods/vim-systemd-syntax', {'frozen': 1}
Plug 'plasticboy/vim-markdown', {'frozen': 1}

" Translator
Plug 'voldikss/vim-translator', {'frozen': 1}

" 注释
Plug 'scrooloose/nerdcommenter', {'frozen': 1}
" outline
"Plug 'vim-voom/VOoM', {'frozen': 1}
"Plug 'preservim/tagbar', {'frozen': 1, 'do': ':lua tagbar()'}
" 对齐
Plug 'junegunn/vim-easy-align', {'frozen': 1}

Plug 'tpope/vim-surround', {'frozen': 1}

"coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'posva/vim-vue'

call plug#end()

syntax on
filetype plugin indent on

lua require("GInit")

au VimEnter * let g:workspace=$PWD
