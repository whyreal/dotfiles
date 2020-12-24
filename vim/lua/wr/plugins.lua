local packer = require("packer")
local use = packer.use

local init = function()

	use { 'wbthomason/packer.nvim',
	config = function()
		local utils = require("wr.utils")
		utils.autocmd("BufWritePost plugins.lua PackerCompile")
	end }

	require"wr.plugin_builtin_lsp".setup()
	-- require"wr.plugin_coc".setup()
	if vim.fn.has('vimr') == 0 then
		require"wr.plugin_treesitter".setup()
	end
	require"wr.plugin_fuzzy_finder".setup()
	require"wr.plugin_theme".setup()
	require"wr.plugin_markdown".setup()

	use { 'hrsh7th/vim-vsnip',
	requires = {{'hrsh7th/vim-vsnip-integ'}},
	config = function()
		local utils = require("wr.utils")
		vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/snippets"

		utils.map('i', '<c-!>sej', [[<Plug>(vsnip-expand-or-jump)]] )
		utils.map('s', '<c-!>sjn', [[<Plug>(vsnip-jump-next)]] )
		utils.map('s', '<c-!>sjp', [[<Plug>(vsnip-jump-prev)]] )

		utils.maplua('i', '<CR>',    "require[[wr.imap]].cr()")
		utils.maplua('i', '<TAB>',   "require[[wr.imap]].tab()")
		utils.maplua('s', '<TAB>',   "require[[wr.smap]].tab()")
		utils.maplua('i', '<S-TAB>', "require[[wr.imap]].stab()")
		utils.maplua('s', '<S-TAB>', "require[[wr.smap]].stab()")
	end }

	-- insert mode auto-completion for quotes, parens, brackets, etc.
	use {'Raimondi/delimitMate', lock = true, }

	-- 输入法切换
	-- [smartim](https://github.com/ybian/smartim)
	use { 'ybian/smartim', lock = true,
	-- use [macism](https://github.com/laishulu/macism/) as Input Source Manager
	-- 其他切换工具切换书输入法后无法正常使用
	run = 'cp /usr/local/bin/macism plugin/im-select' }

	------------------
	-- Translator
	------------------
	use { 'voldikss/vim-translator',
	lock = true,
	config = function()
		local utils = require("wr.utils")
		vim.g.translator_default_engines = {'bing', 'google'}
		vim.g.translator_history_enable = true

		-- Echo translation in the cmdline
		utils.map('n', '<leader>tc', '<Plug>Translate')
		utils.map('v', '<leader>tc', '<Plug>TranslateV')
		-- Display translation in a window
		utils.map('n', '<leader>tw', '<Plug>TranslateW')
		utils.map('v', '<leader>tw', '<Plug>TranslateWV')
		utils.map('n', '<LocalLeader>w', '<Plug>TranslateW')
		utils.map('v', '<LocalLeader>w', '<Plug>TranslateWV')
		-- Replace the text with translation
		utils.map('n', '<leader>tr', '<Plug>TranslateR')
		utils.map('v', '<leader>tr', '<Plug>TranslateRV')
		-- Translate the text in clipboard
		utils.map('x', '<leader>x', '<Plug>TranslateX')

	end }

	-- 平滑滚动
	-- https://github.com/psliwka/vim-smoothie
	use {'psliwka/vim-smoothie', lock = true}

	-- 注释
	use {'scrooloose/nerdcommenter', lock = true}

	-----------------
	-- 导航
	-----------------
	use { 'vim-voom/VOoM',
	lock = true,
	config = function()
		local utils = require("wr.utils")
		vim.g.voom_tree_placement = 'right'
		vim.g.voom_ft_modes = {markdown = 'pandoc', vim = 'fmr'}
		vim.g.voom_always_allow_move_left = 1
		utils.map('n', '<leader>vv', ':VoomToggle<CR>')
	end }

	use { 'preservim/tagbar',
	lock = true,
	config = function ()
		local utils = require("wr.utils")
		utils.map('n', '<leader>vt', ':TagbarToggle<CR>')
	end }

	-- Terminal
	use {'christoomey/vim-tmux-navigator', lock = true}
	-- https://github.com/habamax/vim-sendtoterm
	use {'habamax/vim-sendtoterm', lock = true}

	-- 对齐
	use { 'junegunn/vim-easy-align',
	lock = true,
	config = function()
		local utils = require("wr.utils")
		-- Start interactive EasyAlign in visual mode (e.g. vipga)
		utils.map('x', 'ga', '<Plug>(EasyAlign)')
		-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
		utils.map('n', 'ga', '<Plug>(EasyAlign)')
	end }

	use { 'tpope/vim-surround', lock = true,}

	-- 内存消耗太严重了
	--use {"aca/completion-tabnine", run = './install.sh'}
end

packer.init({
	compile_path = vim.fn.stdpath('config') .. '/plugin/packer_compiled.vim'
})

packer.reset()
return packer.startup(init)
