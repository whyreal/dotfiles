local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function()
    use {
        'junegunn/fzf',
        run = ':call fzf#install()',
        config = function()
            vim.g.fzf_preview_window = {'right:50%:hidden', 'alt-p'}
        end
    }

    use {
        'junegunn/fzf.vim',
        config = function()
            local utils = require("wr.utils")
            utils.map('n', '<leader>fm', ':Marks<CR>')
            utils.maplua('n', '<leader>ff', 'require("wr.fzfwrapper").files()')
            utils.maplua('n', '<leader>fb', 'require("wr.fzfwrapper").buffers()')
            utils.maplua('n', '<leader>fg', 'require("wr.fzfwrapper").grep()')
            utils.map('n', '<leader>fw', ':Windows<CR>')
            utils.map('n', '<leader>fc', ':Commands<CR>')
            utils.map('n', '<leader>f/', ':History/<CR>')
            utils.map('n', '<leader>f;', ':History:<CR>')
            utils.map('n', '<leader>fr', ':History<CR>')
            utils.map('n', '<leader>fl', ':BLines<CR>')

            utils.new_cmd('-nargs=* Rg',
                          'call luaeval("require[[wr.fzfwrapper]].rg(_A)", shellescape(<q-args>))')
        end
    }
end

return M
