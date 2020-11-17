-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

wr = {}

wr.map_opts = {noremap = false, silent = false, expr = false}

wr.map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', wr.map_opts, opts or {})
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

wr.autocmd = function(cmd) vim.api.nvim_command("autocmd " .. cmd) end

wr.check_back_space = function ()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

return require('packer').startup(function()

    -- Packer can manage itself as an optional plugin
    use {
        'wbthomason/packer.nvim',
        -- opt = true,
        config = function()
            wr.autocmd("BufWritePost plugins.lua PackerCompile")
        end
    }

    use {
        'nvim-lua/completion-nvim',
        lock = true,
        config = function()
            wr.autocmd("BufEnter * lua require'completion'.on_attach()")

            vim.g.completion_enable_auto_hover = 0
            vim.g.completion_auto_change_source = 1
            vim.g.completion_matching_ignore_case = 1
            vim.g.completion_enable_snippet = 'vim-vsnip'
            vim.g.completion_confirm_key = ""
            vim.g.completion_chain_complete_list =
                {
                    {complete_items = {'lsp', 'snippet', 'buffers', 'path'}},
                    {mode = '<c-p>'}, {mode = '<c-n>'}
                }

        end
    }
    use {
        'hrsh7th/vim-vsnip',
        requires = {{'hrsh7th/vim-vsnip-integ'}},
        config = function()
            vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/snippets"
            wr.map('i', '<CR>', [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_confirm_completion)" : "\<c-e>\<CR>" : (delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<CR>")]], {expr = true})

            wr.map('i', '<TAB>', [[pumvisible() ? "\<C-n>" : vsnip#available(1) ? "\<Plug>(vsnip-expand-or-jump)" : v:lua.wr.check_back_space() ? "\<TAB>" : completion#trigger_completion()]], {expr = true})
            wr.map('s', '<TAB>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<Tab>"]], {expr = true})

            wr.map('i', '<S-TAB>', [[pumvisible() ? "\<C-p>" : "\<C-h>"]], {expr = true})
            wr.map('s', '<S-TAB>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-prev)" : "\<S-Tab>"]], {expr = true})
        end
    }
    use {'junegunn/fzf', run = ':call fzf#install()'}
    use {
        'junegunn/fzf.vim',
        config = function()
            wr.map('n', '<leader>lm', ':Marks<CR>')
            wr.map('n', '<leader>f', ':Files<CR>')
            wr.map('n', '<leader>lb', ':Buffers<CR>')
            wr.map('n', '<leader>lw', 'Windows<CR>')
            wr.map('n', '<leader>lc', 'Commands<CR>')
        end
    }

    -- insert mode auto-completion for quotes, parens, brackets, etc.
    use {'Raimondi/delimitMate'}

    -- Color Theme
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "maintained",
                highlight = {enable = true}
            }
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
        end
    }
    use {'NLKNguyen/papercolor-theme', lock = true}
    use {'challenger-deep-theme/vim', lock = true}
    use {
        'altercation/vim-colors-solarized',
        lock = true,
        config = function()
            vim.g.solarized_termcolors = 256
            vim.g.solarized_termtrans = 1
            vim.g.solarized_underline = 0
        end
    }

    -- 输入法切换
    -- [smartim](https://github.com/ybian/smartim)
    use {
        'ybian/smartim',
        lock = true,
        -- use [macism](https://github.com/laishulu/macism/) as Input Source Manager
        run = 'cp /usr/local/bin/macism plugin/im-select'
    }

    ------------------
    -- Translator
    ------------------
    use {
        'voldikss/vim-translator',
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
            wr.map('n', '<space>w', '<Plug>TranslateW')
            wr.map('v', '<space>w', '<Plug>TranslateWV')
            -- Replace the text with translation
            wr.map('n', '<leader>tr', '<Plug>TranslateR')
            wr.map('v', '<leader>tr', '<Plug>TranslateRV')
            -- Translate the text in clipboard
            wr.map('x', '<leader>x', '<Plug>TranslateX')
        end
    }

    -- 平滑滚动
    -- https://github.com/psliwka/vim-smoothie
    use {'psliwka/vim-smoothie', lock = true}

    -- Syntax
    use {'Glench/Vim-Jinja2-Syntax', lock = true}
    use {'neoclide/jsonc.vim', lock = true}

    -- 注释
    use {'scrooloose/nerdcommenter', lock = true}

    -----------------
    -- 导航
    -----------------
    vim.g.netrw_winsize = 30
    -- 0 keep the current directory the same as the browsing directory.
    -- let g:netrw_keepdir=0
    vim.g.netrw_bookmarklist = "[$PWD]"

    use {
        'vim-voom/VOoM',
        lock = true,
        config = function()
            vim.g.voom_tree_placement = 'right'
            vim.g.voom_ft_modes = {markdown = 'pandoc', vim = 'fmr'}
            vim.g.voom_always_allow_move_left = 1
            wr.map('n', '<leader>vv', ':VoomToggle<CR>')
        end
    }

    -- Terminal
    use {'christoomey/vim-tmux-navigator', lock = true}
    -- https://github.com/habamax/vim-sendtoterm
    use {'habamax/vim-sendtoterm', lock = true}

    -----------------
    -- Markdown
    -----------------
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app & yarn install',
        lock = true
    }
    use {
        'plasticboy/vim-markdown',
        lock = true,
        config = function()
            -- Fix: Folding and Unfolding when typing in insert mode
            -- https://github.com/plasticboy/vim-markdown/issues/414
            vim.g.vim_markdown_folding_style_pythonic = 1
            vim.g.vim_markdown_folding_level = 0
            vim.g.vim_markdown_follow_anchor = 1
            vim.o.conceallevel = 2
            wr.autocmd("Filetype markdown set fdm=expr")
        end
    }

    -- 对齐
    use {
        'junegunn/vim-easy-align',
        lock = true,
        config = function()
            -- Start interactive EasyAlign in visual mode (e.g. vipga)
            wr.map('x', 'ga', '<Plug>(EasyAlign)')
            -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
            wr.map('n', 'ga', '<Plug>(EasyAlign)')
        end
    }

end)
