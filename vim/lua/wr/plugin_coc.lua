local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function()
	use {'neoclide/coc.nvim',
	branch = 'release',
	config = function()
		vim.cmd [[source ~/.vim/lua/wr/coc_config.vim]]
	end }
end

return M
