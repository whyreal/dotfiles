return require('packer').startup(function()

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
				{complete_items = {'lsp', 'snippet', 'buffers', 'path'}},
				{mode = '<c-p>'}, {mode = '<c-n>'}
			}

			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics, {
				underline = true,
				virtual_text = false,
				signs = true,
				update_in_insert = false,
			})

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
				end
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
	--use {'junegunn/fzf', run = ':call fzf#install()'}
	use { 'junegunn/fzf.vim',
		config = function()
			wr.map('n', '<leader>fm', ':Marks<CR>')
			wr.map('n', '<leader>ff', ':Files<CR>')
			wr.map('n', '<leader>fb', ':Buffers<CR>')
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

	-- Color Theme
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
	use { 'iamcco/markdown-preview.nvim',
		run = 'cd app & yarn install',
		lock = true
	}
	use { 'plasticboy/vim-markdown',
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
	use { 'glepnir/galaxyline.nvim',
		branch = 'main',
		disable = true,
		config = function()
			local gl = require('galaxyline')
			local gls = gl.section
			gl.short_line_list = {'LuaTree','vista','dbui'}

			local colors = {
				bg = '#282c34',
				line_bg = '#353644',
				fg = '#8FBCBB',
				fg_green = '#65a380',

				yellow = '#fabd2f',
				cyan = '#008080',
				darkblue = '#081633',
				green = '#afd700',
				orange = '#FF8800',
				purple = '#5d4d7a',
				magenta = '#c678dd',
				blue = '#51afef';
				red = '#ec5f67'
			}

			local buffer_not_empty = function()
				if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
					return true
				end
				return false
			end

			gls.left[1] = {
				FirstElement = {
					provider = function() return '▊ ' end,
					highlight = {colors.blue,colors.line_bg}
				},
			}
			gls.left[2] = {
				ViMode = {
					provider = function()
						-- auto change color according the vim mode
						local mode_color = {n = colors.magenta, i = colors.green,v=colors.blue,[''] = colors.blue,V=colors.blue,
						c = colors.red,no = colors.magenta,s = colors.orange,S=colors.orange,
						[''] = colors.orange,ic = colors.yellow,R = colors.purple,Rv = colors.purple,
						cv = colors.red,ce=colors.red, r = colors.cyan,rm = colors.cyan, ['r?'] = colors.cyan,
						['!']  = colors.red,t = colors.red}
						vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
						return '  '
					end,
					highlight = {colors.red,colors.line_bg,'bold'},
				},
			}
			gls.left[3] ={
				FileIcon = {
					provider = 'FileIcon',
					condition = buffer_not_empty,
					highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.line_bg},
				},
			}
			gls.left[4] = {
				FileName = {
					provider = {'FileName','FileSize'},
					condition = buffer_not_empty,
					highlight = {colors.fg,colors.line_bg,'bold'}
				}
			}

			--[[
			   [gls.left[5] = {
			   [    GitIcon = {
			   [        provider = function() return '  ' end,
			   [        condition = require('galaxyline.provider_vcs').check_git_workspace,
			   [        highlight = {colors.orange,colors.line_bg},
			   [    }
			   [}
			   [gls.left[6] = {
			   [    GitBranch = {
			   [        provider = 'GitBranch',
			   [        condition = require('galaxyline.provider_vcs').check_git_workspace,
			   [        highlight = {'#8FBCBB',colors.line_bg,'bold'},
			   [    }
			   [}
			   ]]

			--local checkwidth = function()
				--local squeeze_width  = vim.fn.winwidth(0) / 2
				--if squeeze_width > 40 then
					--return true
				--end
				--return false
			--end

			--gls.left[7] = {
				--DiffAdd = {
					--provider = 'DiffAdd',
					--condition = checkwidth,
					--icon = ' ',
					--highlight = {colors.green,colors.line_bg},
				--}
			--}
			--gls.left[8] = {
				--DiffModified = {
					--provider = 'DiffModified',
					--condition = checkwidth,
					--icon = ' ',
					--highlight = {colors.orange,colors.line_bg},
				--}
			--}
			--gls.left[9] = {
				--DiffRemove = {
					--provider = 'DiffRemove',
					--condition = checkwidth,
					--icon = ' ',
					--highlight = {colors.red,colors.line_bg},
				--}
			--}
			--[[
			   [gls.left[10] = {
			   [    LeftEnd = {
			   [        provider = function() return '' end,
			   [        separator = '',
			   [        separator_highlight = {colors.bg,colors.line_bg},
			   [        highlight = {colors.line_bg,colors.line_bg}
			   [    }
			   [}
			   ]]
			gls.left[11] = {
				DiagnosticError = {
					provider = 'DiagnosticError',
					icon = '  ',
					highlight = {colors.red,colors.bg}
				}
			}
			gls.left[12] = {
				Space = {
					provider = function () return ' ' end
				}
			}
			gls.left[13] = {
				DiagnosticWarn = {
					provider = 'DiagnosticWarn',
					icon = '  ',
					highlight = {colors.blue,colors.bg},
				}
			}
			gls.right[1]= {
				FileFormat = {
					provider = 'FileFormat',
					--separator = ' ',
					separator_highlight = {colors.bg,colors.line_bg},
					highlight = {colors.fg,colors.line_bg,'bold'},
				}
			}
			gls.right[2] = {
				LineInfo = {
					provider = 'LineColumn',
					separator = ' | ',
					separator_highlight = {colors.blue,colors.line_bg},
					highlight = {colors.fg,colors.line_bg},
				},
			}
			gls.right[3] = {
				PerCent = {
					provider = 'LinePercent',
					separator = ' ',
					separator_highlight = {colors.line_bg,colors.line_bg},
					highlight = {colors.cyan,colors.darkblue,'bold'},
				}
			}
			gls.right[4] = {
				ScrollBar = {
					provider = 'ScrollBar',
					highlight = {colors.blue,colors.purple},
				}
			}

			gls.short_line_left[1] = {
				BufferType = {
					provider = 'FileTypeName',
					separator = '',
					separator_highlight = {colors.purple,colors.bg},
					highlight = {colors.fg,colors.purple}
				}
			}


			gls.short_line_right[1] = {
				BufferIcon = {
					provider= 'BufferIcon',
					separator = '',
					separator_highlight = {colors.purple,colors.bg},
					highlight = {colors.fg,colors.purple}
				}
			}
		end,
		-- some optional icons
	}
	use { 'romgrk/barbar.nvim',
	disable = true,
	config = function()
		wr.map('n', '<A-1>', ':BufferGoto 1<CR>', {silent = true})
		wr.map('n', '<A-2>', ':BufferGoto 2<CR>', {silent = true})
		wr.map('n', '<A-3>', ':BufferGoto 3<CR>', {silent = true})
		wr.map('n', '<A-4>', ':BufferGoto 4<CR>', {silent = true})
		wr.map('n', '<A-5>', ':BufferGoto 5<CR>', {silent = true})
		wr.map('n', '<A-6>', ':BufferGoto 6<CR>', {silent = true})
		wr.map('n', '<A-7>', ':BufferGoto 7<CR>', {silent = true})
		wr.map('n', '<A-8>', ':BufferGoto 8<CR>', {silent = true})
		wr.map('n', '<A-9>', ':BufferLast<CR>', {silent = true})
		--" Magic buffer-picking mode
		--nnoremap <silent> <C-s> :BufferPick<CR>
		--" Sort automatically by...
		--nnoremap <silent> <Space>bd :BufferOrderByDirectory<CR>
		--nnoremap <silent> <Space>bl :BufferOrderByLanguage<CR>
		--" Move to previous/next
		--nnoremap <silent>    <A-,> :BufferPrevious<CR>
		--nnoremap <silent>    <A-.> :BufferNext<CR>
		--" Re-order to previous/next
		--nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
		--nnoremap <silent>    <A->> :BufferMoveNext<CR>
		--" Goto buffer in position...
		--" Close buffer
		--nnoremap <silent>    <A-c> :BufferClose<CR>
		--" Wipeout buffer
		--"                          :BufferWipeout<CR>
		--" Other:
		--" :BarbarEnable - enables barbar (enabled by default)
		--" :BarbarDisable - very bad command, should never be used
	end}

	use {'dag/vim-fish'}

end)
