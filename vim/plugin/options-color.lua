vim.api.nvim_create_autocmd({'ColorScheme', "UIEnter"}, {
    pattern = {"*"},
    callback = function()
        -- fix coclist highlight
        vim.cmd.highlight({"clear", "CocListLine"})
        vim.cmd.highlight({"link", "CocListLine", "Folded"})

      vim.cmd.highlight({"Normal ", "guibg=NONE ctermbg=NONE"})
      vim.cmd.highlight({"NonText ", "guibg=NONE ctermbg=NONE"})
      vim.cmd.highlight({"EndOfBuffer ", "guibg=NONE ctermbg=NONE"})
      --vim.cmd.highlight({"LineNr ", "guibg=NONE ctermbg=NONE"})
      --vim.cmd.highlight({"Folded ", "guibg=NONE ctermbg=NONE"})
      ---- fix coc float win color"
      --vim.cmd.highlight({"link ", "FgCocInfoFloatBgCocFloating", "NormalFloat"})
    end
})

--local scheme = "PaperColor"
local scheme = "tokyonight"
--local scheme = "tokyodark"
--local scheme = "desert"

if vim.env["__CFBundleIdentifier"] == "com.apple.Terminal" then
    vim.o.termguicolors = false
else
    vim.o.termguicolors = true
end

if vim.env["VIMBG"] == "dark" then
    vim.o.background = "dark"
    vim.cmd.colorscheme(scheme)
end

if vim.env["VIMBG"] == "light" then
    vim.o.background = "light"
    vim.cmd.colorscheme(scheme)
end

if vim.fn.has("gui_vimr") == 1 then
    vim.o.background = "light"
    vim.cmd.colorscheme(scheme)
end
