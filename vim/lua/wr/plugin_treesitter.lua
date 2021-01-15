local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function()
	use { 'nvim-treesitter/nvim-treesitter',
	config = function()
		require'nvim-treesitter.configs'.setup {
			ensure_installed = {"lua", "go"},
			highlight = {enable = true}
		}
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
	end }
	use {'nvim-treesitter/completion-treesitter'}
end

return M
