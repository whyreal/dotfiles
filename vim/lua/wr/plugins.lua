local packer = require("packer")
local use = packer.use

local init = function()

	use { 'wbthomason/packer.nvim',
	config = function()
		wr.autocmd("BufWritePost plugins.lua PackerCompile")
	end }

	require"wr.plugin_builtin_lsp".setup()
	--require"wr.plugin_coc".setup()
	if vim.fn.has('vimr') == 0 then
		require"wr.plugin_treesitter".setup()
	end
	require"wr.plugin_fuzzy_finder".setup()
	require"wr.plugin_theme".setup()
	require"wr.plugin_markdown".setup()

	use { 'hrsh7th/vim-vsnip',
	requires = {{'hrsh7th/vim-vsnip-integ'}},
	config = function()
		vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/snippets"

		wr.map('i', '<c-!>sej', [[<Plug>(vsnip-expand-or-jump)]] )
		wr.map('i', '<c-!>sjn', [[<Plug>(vsnip-jump-next)]] )
		wr.map('i', '<c-!>sjp', [[<Plug>(vsnip-jump-prev)]] )

		wr.maplua('i', '<CR>',    "wr.imap_cr()")
		wr.maplua('i', '<TAB>',   "wr.imap_tab()")
		wr.maplua('s', '<TAB>',   "wr.smap_tab()")
		wr.maplua('i', '<S-TAB>', "wr.imap_stab()")
		wr.maplua('s', '<S-TAB>', "wr.smap_stab()")
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
		vim.g.translator_default_engines = {'bing', 'google'}
		vim.g.translator_history_enable = true

		-- Echo translation in the cmdline
		wr.map('n', '<leader>tc', '<Plug>Translate')
		wr.map('v', '<leader>tc', '<Plug>TranslateV')
		-- Display translation in a window
		wr.map('n', '<leader>tw', '<Plug>TranslateW')
		wr.map('v', '<leader>tw', '<Plug>TranslateWV')
		wr.map('n', '<LocalLeader>w', '<Plug>TranslateW')
		wr.map('v', '<LocalLeader>w', '<Plug>TranslateWV')
		-- Replace the text with translation
		wr.map('n', '<leader>tr', '<Plug>TranslateR')
		wr.map('v', '<leader>tr', '<Plug>TranslateRV')
		-- Translate the text in clipboard
		wr.map('x', '<leader>x', '<Plug>TranslateX')

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
		vim.g.voom_tree_placement = 'right'
		vim.g.voom_ft_modes = {markdown = 'pandoc', vim = 'fmr'}
		vim.g.voom_always_allow_move_left = 1
		wr.map('n', '<leader>vv', ':VoomToggle<CR>')
	end }

	use { 'preservim/tagbar',
	lock = true,
	config = function ()
		wr.map('n', '<leader>vt', ':TagbarToggle<CR>')
	end }

	-- Terminal
	use {'christoomey/vim-tmux-navigator', lock = true}
	-- https://github.com/habamax/vim-sendtoterm
	use {'habamax/vim-sendtoterm', lock = true}

	-- 对齐
	use { 'junegunn/vim-easy-align',
	lock = true,
	config = function()
		-- Start interactive EasyAlign in visual mode (e.g. vipga)
		wr.map('x', 'ga', '<Plug>(EasyAlign)')
		-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
		wr.map('n', 'ga', '<Plug>(EasyAlign)')
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
