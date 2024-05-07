vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.ft_man_folding_enable=1

vim.g.mapleader = "," -- make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader=",,"
vim.g.coc_filetype_map = {
    ["yaml.ansible"] = "ansible"
}

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

"nvim-tree/nvim-web-devicons",
--"pearofducks/ansible-vim",
-- buffer line or tab line
--"akinsho/bufferline.nvim",
--"moll/vim-bbye",
-- auto wirte
--"tmillr/sos.nvim",

--" git
"tpope/vim-fugitive",
"junegunn/gv.vim",

--" theme
"NLKNguyen/papercolor-theme",
"morhetz/gruvbox",
"ghifarit53/tokyonight-vim",
"tiagovla/tokyodark.nvim",

--" syntax
"dag/vim-fish",
"nvim-treesitter/nvim-treesitter",

--" Translator
{"voldikss/vim-translator"},
--" 注释
"scrooloose/nerdcommenter",
--" 对齐
"junegunn/vim-easy-align",

--"coc
{"neoclide/coc.nvim", branch = 'release'},
{dir = "~/code/whyreal/wr-coc-helper/"},
{dir = "~/code/whyreal/coc-picgo/"},

--" EasyMotion
{"phaazon/hop.nvim", branch = 'v2', pin = true},
--" plugins in lua
--"nvim-lua/plenary.nvim",
"wellle/tmux-complete.vim",
--"honza/vim-snippets"
})

vim.cmd("syntax off")
