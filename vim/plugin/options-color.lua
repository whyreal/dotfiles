vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
      vim.cmd.highlight({"Normal ", "guibg=NONE ctermbg=NONE"})
      vim.cmd.highlight({"NonText ", "guibg=NONE ctermbg=NONE"})
      --vim.cmd.highlight({"LineNr ", "guibg=NONE ctermbg=NONE"})
      --vim.cmd.highlight({"Folded ", "guibg=NONE ctermbg=NONE"})
      --vim.cmd.highlight({"EndOfBuffer ", "guibg=NONE ctermbg=NONE"})
      ---- fix coc float win color"
      --vim.cmd.highlight({"link ", "FgCocInfoFloatBgCocFloating", "NormalFloat"})
  end,
})

if vim.fn.has("gui_vimr") then
    vim.o.termguicolors = true
    vim.o.background = "light"
    vim.cmd.colorscheme("PaperColor")
end

if vim.env["LC_TERMINAL"] == "iTerm2" then
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("PaperColor")
end

if vim.env["TERMAPP"] == "alacritty" then
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("Gruvbox")
end

if vim.env["TERMAPP"] == "vscode" then
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("PaperColor")
end

if vim.env["__CFBundleIdentifier"] == "com.apple.Terminal" then
    vim.o.termguicolors = false
    vim.o.background = "light"
    vim.cmd.colorscheme("PaperColor")
end
