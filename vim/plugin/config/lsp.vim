lua <<EOF
-- 关闭错误详情
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
-- vim.lsp.diagnostic.on_publish_diagnostics, {
--	underline = true,
--	virtual_text = false,
--	signs = true,
--	update_in_insert = false,
-- })


-- lua
-- sumneko_lua 性能不佳，常驻5% CPU 消耗
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
require'lspconfig'.jedi_language_server.setup {
	root_dir = function(fname) return vim.fn.getcwd() end
}

-- golang
require'lspconfig'.gopls.setup {
	root_dir = function(fname) return vim.fn.getcwd() end
}
require'lspconfig'.jdtls.setup {}
EOF

" nmap <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nmap gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nmap <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nmap 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nmap gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nmap K          <cmd>lua vim.lsp.buf.hover()<CR>
nmap gr         <cmd>lua vim.lsp.buf.references()<CR>
nmap g0         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap gW         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nmap gd         <cmd>lua vim.lsp.buf.definition()<CR>
nmap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

au CursorHold  *.lua,*.go,*.python lua vim.lsp.buf.document_highlight()
au CursorHoldI *.lua,*.go,*.python lua vim.lsp.buf.document_highlight()
au CursorMoved *.lua,*.go,*.python lua vim.lsp.buf.clear_references()
