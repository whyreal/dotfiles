local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function ()
	-- preview
	use {'euclio/vim-markdown-composer',
	lock = true,
	run = 'cargo build --release',
	config = function()
		vim.g.markdown_composer_autostart = 1
		vim.g.markdown_composer_open_browser = 0
	end }

	use { 'plasticboy/vim-markdown',
	lock = true,
	config = function()
		-- Fix: Folding and Unfolding when typing in insert mode
		-- https://github.com/plasticboy/vim-markdown/issues/414
		vim.g.vim_markdown_folding_style_pythonic = 1
		vim.g.vim_markdown_folding_level = 0
		vim.g.vim_markdown_follow_anchor = 1
		--vim.o.conceallevel = 2
	end }

	--use {'SidOfc/mkdx'}
end

return M
