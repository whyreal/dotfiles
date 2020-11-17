-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
--vim._update_package_paths()

return require('packer').startup(function()

	-- Packer can manage itself as an optional plugin
	use {'wbthomason/packer.nvim',
		--opt = true,
		config = function()
			vim.api.nvim_command("autocmd BufWritePost plugins.lua PackerCompile")
		end}

    -- insert mode auto-completion for quotes, parens, brackets, etc.
	use { 'Raimondi/delimitMate'}

	use { 'nvim-treesitter/nvim-treesitter',
		config = function ()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = "maintained",
				highlight = {
					enable = true,
				},
			}
			vim.wo.foldmethod="expr"
			vim.wo.foldexpr="nvim_treesitter#foldexpr()"
		end}

	--Color Theme
	use {'NLKNguyen/papercolor-theme', lock = true }
	use {'challenger-deep-theme/vim', lock = true }
	use {'altercation/vim-colors-solarized', lock = true,
		config = function()
			vim.g.solarized_termcolors = 256
			vim.g.solarized_termtrans  = 1
			vim.g.solarized_underline  = 0
		end}

	--输入法切换
	--[smartim](https://github.com/ybian/smartim)
	use {'ybian/smartim', lock = true,
		--use [macism](https://github.com/laishulu/macism/) as Input Source Manager
		run = 'cp /usr/local/bin/macism plugin/im-select'}

	------------------
	-- Translator
	------------------
	use {'voldikss/vim-translator', lock = true,
		config = function()
			vim.g.translator_default_engines = {'bing', 'google'}
			vim.g.translator_history_enable = true

			--Echo translation in the cmdline
			vim.api.nvim_set_keymap('n', '<leader>tc', '<Plug>Translate',   { noremap = false, silent = false })
			vim.api.nvim_set_keymap('v', '<leader>tc', '<Plug>TranslateV',  { noremap = false, silent = false })
			--Display translation in a window
			vim.api.nvim_set_keymap('n', '<leader>tw', '<Plug>TranslateW',  { noremap = false, silent = false })
			vim.api.nvim_set_keymap('v', '<leader>tw', '<Plug>TranslateWV', { noremap = false, silent = false })
			vim.api.nvim_set_keymap('n', '<space>w',   '<Plug>TranslateW',  { noremap = false, silent = false })
			vim.api.nvim_set_keymap('v', '<space>w',   '<Plug>TranslateWV', { noremap = false, silent = false })
			--Replace the text with translation
			vim.api.nvim_set_keymap('n', '<leader>tr', '<Plug>TranslateR',  { noremap = false, silent = false })
			vim.api.nvim_set_keymap('v', '<leader>tr', '<Plug>TranslateRV', { noremap = false, silent = false })
			--Translate the text in clipboard
			vim.api.nvim_set_keymap('x', '<leader>x',  '<Plug>TranslateX',  { noremap = false, silent = false })
		end}

	--平滑滚动
	--https://github.com/psliwka/vim-smoothie
	use {'psliwka/vim-smoothie', lock = true}

	-- Syntax
	--vim.api.nvim_command("Plug 'ekalinin/Dockerfile.vim'")
	use {'Glench/Vim-Jinja2-Syntax', lock = true}
	use {'neoclide/jsonc.vim', lock = true}

	-- 注释
	use {'scrooloose/nerdcommenter', lock = true}

	-----------------
	-- 导航
	-----------------
	vim.g.netrw_winsize=30
	-- 0 keep the current directory the same as the browsing directory.
	--let g:netrw_keepdir=0
	vim.g.netrw_bookmarklist = "[$PWD]"

	use {'vim-voom/VOoM', lock = true,
		config = function()
			vim.g.voom_tree_placement = 'right'
			vim.g.voom_ft_modes = {markdown = 'pandoc', vim = 'fmr'}
			vim.g.voom_always_allow_move_left = 1
			vim.api.nvim_set_keymap('n', '<leader>vv',      ':VoomToggle<CR>',  { noremap = false, silent = false })
		end}

	-- Terminal
	use {'christoomey/vim-tmux-navigator', lock = true }
	-- https://github.com/habamax/vim-sendtoterm
	use {'habamax/vim-sendtoterm', lock = true }

	-----------------
	-- Markdown
	-----------------
	use {'iamcco/markdown-preview.nvim', run = 'cd app & yarn install', lock = true}
	use {'plasticboy/vim-markdown', lock = true,
		config = function()
			-- Fix: Folding and Unfolding when typing in insert mode
			-- https://github.com/plasticboy/vim-markdown/issues/414
			vim.g.vim_markdown_folding_style_pythonic = 1
			vim.g.vim_markdown_folding_level = 0
			vim.g.vim_markdown_follow_anchor = 1
			vim.o.conceallevel = 2
			vim.api.nvim_command("autocmd Filetype markdown set fdm=expr")
		end}

	-- 对齐
	use {'junegunn/vim-easy-align', lock = true,
		config = function()
			-- Start interactive EasyAlign in visual mode (e.g. vipga)
			vim.api.nvim_set_keymap('x', 'ga',      '<Plug>(EasyAlign)',                      { noremap = false, silent = false })
			-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
			vim.api.nvim_set_keymap('n', 'ga',      '<Plug>(EasyAlign)',                      { noremap = false, silent = false })
		end}

end)
