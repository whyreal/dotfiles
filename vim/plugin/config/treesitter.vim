" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = {"lua", "go"},
	highlight = {enable = true}
}
EOF
"vim.wo.foldmethod = "expr"
"vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
