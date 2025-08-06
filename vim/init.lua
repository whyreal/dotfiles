vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.ft_man_folding_enable = 1

vim.g.mapleader = "," -- make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = ",,"

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

    --" theme
    --"sheerun/vim-polyglot",
    "joshdick/onedark.vim",
    --"NLKNguyen/papercolor-theme",
    --"morhetz/gruvbox",
    --"ghifarit53/tokyonight-vim",
    --"tiagovla/tokyodark.nvim",

    --" syntax
    "dag/vim-fish",
    "nvim-treesitter/nvim-treesitter",

    --" Translator
    { "voldikss/vim-translator" },
    --" 注释
    "scrooloose/nerdcommenter",
    --" 对齐
    "junegunn/vim-easy-align",

    --"coc
    { "neoclide/coc.nvim",                  branch = 'release' },
    { dir = "~/code/whyreal/wr-coc-helper/" },

    --" EasyMotion
    --{ "folke/flash.nvim",                   event = "VeryLazy", },
    --{"easymotion/vim-easymotion"},
	{"q9w/hop.vim"},

    --" plugins in lua
    --"wellle/tmux-complete.vim",
    --"honza/vim-snippets"
})

vim.cmd("syntax off")
