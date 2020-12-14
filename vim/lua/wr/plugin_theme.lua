local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function ()
		
	-- icons
	use { 'kyazdani42/nvim-web-devicons'}

	-- theme
	use {'NLKNguyen/papercolor-theme', lock = true}
	use {'challenger-deep-theme/vim', lock = true}
	use { 'altercation/vim-colors-solarized',
	lock = true,
	config = function()
		vim.g.solarized_termcolors = 256
		vim.g.solarized_termtrans = 1
		vim.g.solarized_underline = 0
	end }

	-- Syntax
	use {'Glench/Vim-Jinja2-Syntax', lock = true}
	use {'neoclide/jsonc.vim', lock = true}
	use { 'dag/vim-fish', lock = true }

end

return M
