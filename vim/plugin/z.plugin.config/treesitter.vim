lua <<EOF
require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {},  -- list of language that will be disabled
    },
}
EOF
