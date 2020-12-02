return require('packer').startup(function(use)

	use { 'wbthomason/packer.nvim',
		config = function()
			wr.autocmd("BufWritePost plugins.lua PackerCompile")
		end
	}
	use { 'nvim-lua/completion-nvim',
		lock = true,
		config = function()
			wr.autocmd("BufEnter * lua require'completion'.on_attach()")

			vim.g.completion_sorting = "none"
			vim.g.completion_trigger_keyword_length = 2
			vim.g.completion_trigger_on_delete = 1
			vim.g.completion_enable_auto_hover = 0
			vim.g.completion_auto_change_source = 1
			vim.g.completion_matching_smart_case = 1
			--vim.g.completion_matching_ignore_case = 1
			vim.g.completion_matching_strategy_list = {'fuzzy', 'substring'}
			--vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
			vim.g.completion_enable_snippet = 'vim-vsnip'
			vim.g.completion_confirm_key = ""
			vim.g.completion_chain_complete_list = {
				{complete_items = {'lsp', 'snippet', 'buffers', 'ts', 'path'}},
				{mode = '<c-p>'}, {mode = '<c-n>'}
			}

			--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
			--vim.lsp.diagnostic.on_publish_diagnostics, {
			--	underline = true,
			--	virtual_text = false,
			--	signs = true,
			--	update_in_insert = false,
			--})

		end
	}
	use { 'neovim/nvim-lspconfig',
		--disable = true,
		config = function ()
			-- lua
			require'lspconfig'.sumneko_lua.setup{
				cmd = { "/Users/Real/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
				"-E", "/Users/Real/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/main.lua" },
				install_dir = "/Users/Real/.cache/nvim/lspconfig/sumneko_lua",
				is_installed = true,
				filetypes = { "lua" },
				root_dir = function(fname)
					return vim.fn.getcwd()
				end,
				settings = {
					Lua = {
						diagnostics = {
							disable = {
								"undefined-global",
								"unused-local"
							}
						}
					}
				}
			}

			-- python
			require'lspconfig'.jedi_language_server.setup{
				root_dir = function(fname)
					return vim.fn.getcwd()
				end
			}

			-- golang
			require'lspconfig'.gopls.setup{
				root_dir = function(fname)
					return vim.fn.getcwd()
				end
			}
			require'lspconfig'.jdtls.setup{}

            --wr.map('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
            wr.map('n', 'K',     '<cmd>lua vim.lsp.buf.hover()<CR>')
            --wr.map('n', 'gD',    '<cmd>lua vim.lsp.buf.implementation()<CR>')
            --wr.map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
            --wr.map('n', '1gD',   '<cmd>lua vim.lsp.buf.type_definition()<CR>')
            wr.map('n', 'gr',    '<cmd>lua vim.lsp.buf.references()<CR>')
            wr.map('n', 'g0',    '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
            wr.map('n', 'gW',    '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
            --wr.map('n', 'gd',    '<cmd>lua vim.lsp.buf.declaration()<CR>')
            wr.map('n', 'gd',    '<cmd>lua vim.lsp.buf.definition()<CR>')

		end
	}
	use { 'hrsh7th/vim-vsnip',
		requires = {{'hrsh7th/vim-vsnip-integ'}},
		config = function()
			vim.g.vsnip_snippet_dir = vim.env.HOME .. "/.config/nvim/snippets"
			wr.map('i', '<CR>', "v:lua.wr.imap_cr()", {expr = true})
			wr.map('i', '<TAB>', [[v:lua.wr.imap_tab() ? "" : "\<Plug>(vsnip-expand-or-jump)"]], {expr = true})
			wr.map('s', '<TAB>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<Tab>"]], {expr = true})

			wr.map('i', '<S-TAB>', [[pumvisible() ? "\<C-p>" : "\<C-h>"]], {expr = true})
			wr.map('s', '<S-TAB>', [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-prev)" : "\<S-Tab>"]], {expr = true})
		end
	}
	use {'junegunn/fzf',
		run = ':call fzf#install()',
		config = function()
			vim.g.fzf_preview_window = {'right:50%:hidden', 'alt-p'}
		end}

	use { 'junegunn/fzf.vim',
		config = function()
			wr.map('n', '<leader>fm', ':Marks<CR>')
			wr.map('n', '<leader>ff', '<cmd>lua wr.fzfwrap.files()<cr>')
			wr.map('n', '<leader>fb', '<cmd>lua wr.fzfwrap.buffers()<cr>')
			wr.map('n', '<leader>fw', ':Windows<CR>')
			wr.map('n', '<leader>fc', ':Commands<CR>')
			wr.map('n', '<leader>f/', ':History/<CR>')
			wr.map('n', '<leader>f;', ':History:<CR>')
			wr.map('n', '<leader>fr', ':History<CR>')
			wr.map('n', '<leader>fl', ':BLines<CR>')
		end
	}

	-- insert mode auto-completion for quotes, parens, brackets, etc.
	use {'Raimondi/delimitMate'}

	use { 'nvim-treesitter/nvim-treesitter',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = "maintained",
				highlight = {enable = true}
			}
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
		end
	}

	use {'nvim-treesitter/completion-treesitter'}

	use {'NLKNguyen/papercolor-theme', lock = true}
	use {'challenger-deep-theme/vim', lock = true}
	use { 'altercation/vim-colors-solarized',
		lock = true,
		config = function()
			vim.g.solarized_termcolors = 256
			vim.g.solarized_termtrans = 1
			vim.g.solarized_underline = 0
		end
	}

	-- 输入法切换
	-- [smartim](https://github.com/ybian/smartim)
	use { 'ybian/smartim',
		lock = true,
		-- use [macism](https://github.com/laishulu/macism/) as Input Source Manager
		run = 'cp /usr/local/bin/macism plugin/im-select'
	}

	------------------
	-- Translator
	------------------
	use { 'voldikss/vim-translator',
		lock = true,
		config = function()
			vim.g.translator_default_engines = {'bing'}
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

	use { 'vim-voom/VOoM',
		lock = true,
		config = function()
			vim.g.voom_tree_placement = 'right'
			vim.g.voom_ft_modes = {markdown = 'pandoc', vim = 'fmr'}
			vim.g.voom_always_allow_move_left = 1
			wr.map('n', '<leader>vv', ':VoomToggle<CR>')
		end
	}

	use { 'preservim/tagbar',
		config = function ()
			wr.map('n', '<leader>vt', ':TagbarToggle<CR>')
		end
	}

	-- Terminal
	use {'christoomey/vim-tmux-navigator', lock = true}
	-- https://github.com/habamax/vim-sendtoterm
	use {'habamax/vim-sendtoterm', lock = true}

	-----------------
	-- Markdown
	-----------------
	use {'euclio/vim-markdown-composer',
		lock = true,
		run = 'cargo build --release'}

	use { 'plasticboy/vim-markdown',
		lock = true,
		config = function()
			-- Fix: Folding and Unfolding when typing in insert mode
			-- https://github.com/plasticboy/vim-markdown/issues/414
			vim.g.vim_markdown_folding_style_pythonic = 1
			vim.g.vim_markdown_folding_level = 0
			vim.g.vim_markdown_follow_anchor = 1
			--vim.o.conceallevel = 2
			wr.autocmd("Filetype markdown set fdm=expr")
		end
	}

	-- 对齐
	use { 'junegunn/vim-easy-align',
		lock = true,
		config = function()
			-- Start interactive EasyAlign in visual mode (e.g. vipga)
			wr.map('x', 'ga', '<Plug>(EasyAlign)')
			-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
			wr.map('n', 'ga', '<Plug>(EasyAlign)')
		end
	}
	use {'kyazdani42/nvim-web-devicons'}

	use {'dag/vim-fish'}
    use {'tpope/vim-surround',
		config = function()
			vim.g.markdown_composer_autostart = 0
		end}

end)
