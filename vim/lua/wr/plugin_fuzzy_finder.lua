local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function ()
	use {'junegunn/fzf',
	run = ':call fzf#install()',
	config = function()
		vim.g.fzf_preview_window = {'right:50%:hidden', 'alt-p'}
	end }

	use { 'junegunn/fzf.vim',
	config = function()
		wr.map('n', '<leader>fm', ':Marks<CR>')
		wr.maplua('n', '<leader>ff', 'wr.fzfwrap.files()')
		wr.maplua('n', '<leader>fb', 'wr.fzfwrap.buffers()')
		wr.map('n', '<leader>fw', ':Windows<CR>')
		wr.map('n', '<leader>fc', ':Commands<CR>')
		wr.map('n', '<leader>f/', ':History/<CR>')
		wr.map('n', '<leader>f;', ':History:<CR>')
		wr.map('n', '<leader>fr', ':History<CR>')
		wr.map('n', '<leader>fl', ':BLines<CR>')
	end }
end

return M
