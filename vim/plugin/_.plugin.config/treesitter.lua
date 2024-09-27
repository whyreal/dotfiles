require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "jsdoc",
        "markdown",
        "javascript",
        "typescript",
        "css",
        "html",
        "java",
        "yaml",
    },
    -- List of parsers to ignore installing
    ignore_install = {},
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {},  -- list of language that will be disabled
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    }
}
