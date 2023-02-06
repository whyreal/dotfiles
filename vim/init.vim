let g:loaded_python3_provider = 0
let g:loaded_python_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

let g:mapleader=","
let g:maplocalleader=" "

call plug#begin()
"Plug 'tpope/vim-sensible'
"Plug 'chrisbra/unicode.vim'

Plug 'editorconfig/editorconfig-vim'

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
"Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'neoclide/jsonc.vim'
Plug 'dag/vim-fish'
Plug 'wizicer/vim-jison'
"Plug 'wgwoods/vim-systemd-syntax'
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

" coc-smartim
"cd /Users/Real/.config/coc/extensions/node_modules
"cp /usr/local/bin/macism coc-imselect/bin/select

"coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug '~/code/whyreal/wr-coc-helper/', {'do': 'yarn install --frozen-lockfile'}
Plug '~/code/whyreal/coc-picgo/', {'do': 'yarn install --frozen-lockfile'}

Plug 'rafcamlet/coc-nvim-lua'
Plug 'euclidianAce/BetterLua.vim'

"Plug 'godlygeek/tabular'
"Plug 'preservim/vim-markdown'
"Plug 'mzlogin/vim-markdown-toc'
"Plug 'masukomi/vim-markdown-folding'

Plug 'moll/vim-bbye'

" EasyMotion
Plug 'phaazon/hop.nvim', {'branch': 'v2'}

" explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" plugins in lua
Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'
Plug 'wellle/tmux-complete.vim'

Plug 'honza/vim-snippets'

call plug#end()

syntax off
"syntax enable
"filetype plugin indent on

" 根据焦点变化自动保存或读取文件
"au FocusGained,BufEnter * :silent! !
"au FocusLost,WinLeave * :silent! w
