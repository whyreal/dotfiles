vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.ft_man_folding_enable=1

vim.g.mapleader = "," -- make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader=" "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    
"editorconfig/editorconfig-vim",
"tmillr/sos.nvim",
--"GlancingMind/vim-baker",
--" git
"tpope/vim-fugitive",
"junegunn/gv.vim",

--" theme
"NLKNguyen/papercolor-theme",
"morhetz/gruvbox",
"ghifarit53/tokyonight-vim",
"tiagovla/tokyodark.nvim",

--" syntax
--"Plug 'Glench/Vim-Jinja2-Syntax'
--Plug 'neoclide/jsonc.vim'
"dag/vim-fish",
--Plug 'wizicer/vim-jison'
--"Plug 'wgwoods/vim-systemd-syntax'
--Plug 'godlygeek/tabular'
--Plug 'pprovost/vim-ps1'
--Plug 'chr4/nginx.vim'
--Plug 'pearofducks/ansible-vim'

"nvim-treesitter/nvim-treesitter",

--" Translator
{"voldikss/vim-translator", pin = true},
--" 注释
"scrooloose/nerdcommenter",
--" 对齐
"junegunn/vim-easy-align",

--Plug 'tpope/vim-surround'

--" 输入法切换
--" [smartim](https://github.com/ybian/smartim)
--" use [macism](https://github.com/laishulu/macism/) as Input Source Manager
	--" 其他切换工具切换书输入法后无法正常使用
--"Plug 'ybian/smartim', {'frozen':1, 'do': 'cp /usr/local/bin/macism plugin/im-select'}

--" coc-smartim
--"cd /Users/Real/.config/coc/extensions/node_modules
--"cp /usr/local/bin/macism coc-imselect/bin/select

--"coc
{"neoclide/coc.nvim", branch = 'release'},

{dir = "~/code/whyreal/wr-coc-helper/"},
{dir = "~/code/whyreal/coc-picgo/"},

--Plug 'rafcamlet/coc-nvim-lua'
--Plug 'euclidianAce/BetterLua.vim'

--Plug 'moll/vim-bbye'

--" EasyMotion
{"phaazon/hop.nvim", branch = 'v2', pin = true},

--" plugins in lua
"nvim-lua/plenary.nvim",
"wellle/tmux-complete.vim",
"honza/vim-snippets"
})

vim.cmd("syntax off")
