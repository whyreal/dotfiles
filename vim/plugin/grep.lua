if vim.call("executable", "rg") then
    vim.o.grepprg="rg --vimgrep"
    --vim.o.grepprg="rg --vimgrep --no-ignore"
end
