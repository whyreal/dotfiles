local packer = require("packer")
local use = packer.use
local M = {}

M.setup = function()
    use {
        'nvim-lua/completion-nvim',
        -- lock = true,
        config = function()
            local utils = require("wr.utils")
            utils.autocmd("BufEnter * lua require'completion'.on_attach()")

            vim.g.completion_sorting = "none"
            vim.g.completion_trigger_keyword_length = 2
            vim.g.completion_trigger_on_delete = 1
            vim.g.completion_enable_auto_hover = 0
            vim.g.completion_auto_change_source = 1
            vim.g.completion_matching_smart_case = 1
            -- vim.g.completion_matching_ignore_case = 1
            vim.g.completion_matching_strategy_list = {'fuzzy', 'substring'}
            -- vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
            vim.g.completion_enable_snippet = 'vim-vsnip'
            vim.g.completion_confirm_key = ""
            vim.g.completion_chain_complete_list =
                {
                    {
                        complete_items = {
                            'lsp', 'snippet', 'ts', 'buffers'
                            -- 'tabnine',
                            -- 'path'
                        }
                    }, {mode = '<c-p>'}, {mode = '<c-n>'}
                }

            -- 关闭错误详情
            -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            -- vim.lsp.diagnostic.on_publish_diagnostics, {
            --	underline = true,
            --	virtual_text = false,
            --	signs = true,
            --	update_in_insert = false,
            -- })

        end
    }

    use {
        'neovim/nvim-lspconfig',
        -- disable = true,
        config = function()

            -- lua
            -- sumneko_lua 性能不佳，常驻5% CPU 消耗
            -- require'lspconfig'.sumneko_lua.setup{
            -- cmd = { "/Users/Real/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
            -- "-E", "/Users/Real/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua" },
            -- install_dir = "/Users/Real/.cache/nvim/lspconfig/sumneko_lua",
            -- is_installed = true,
            -- filetypes = { "lua" },
            -- root_dir = function(fname)
            -- return vim.fn.getcwd()
            -- end,
            -- settings = {
            -- Lua = {
            -- diagnostics = {
            -- disable = {
            -- "undefined-global",
            -- "unused-local"
            -- }
            -- }
            -- }
            -- }
            -- }

            -- python
            require'lspconfig'.jedi_language_server.setup {
                root_dir = function(fname) return vim.fn.getcwd() end
            }

            -- golang
            require'lspconfig'.gopls.setup {
                root_dir = function(fname) return vim.fn.getcwd() end
            }
            require'lspconfig'.jdtls.setup {}

            local utils = require("wr.utils")
            -- wr.map('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
            utils.map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
            -- wr.map('n', 'gD',    '<cmd>lua vim.lsp.buf.implementation()<CR>')
            -- wr.map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
            -- wr.map('n', '1gD',   '<cmd>lua vim.lsp.buf.type_definition()<CR>')
            utils.map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
            utils.map('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
            utils.map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
            -- wr.map('n', 'gd',    '<cmd>lua vim.lsp.buf.declaration()<CR>')
            utils.map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
            utils.map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

            utils.autocmd [[CursorHold  *.lua,*.go,*.python lua vim.lsp.buf.document_highlight()]]
            utils.autocmd [[CursorHoldI *.lua,*.go,*.python lua vim.lsp.buf.document_highlight()]]
            utils.autocmd [[CursorMoved *.lua,*.go,*.python lua vim.lsp.buf.clear_references()]]

            vim.cmd [[hi! link LspReferenceText Search]]
            vim.cmd [[hi! link LspReferenceRead Search]]
            vim.cmd [[hi! link LspReferenceWrite Search]]
        end
    }
end

return M
