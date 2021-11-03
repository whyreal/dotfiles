augroup clean_bg
    au!
    au ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    au ColorScheme * highlight NonText guibg=NONE ctermbg=NONE
    au ColorScheme * highlight LineNr guibg=NONE ctermbg=NONE
    au ColorScheme * highlight Folded guibg=NONE ctermbg=NONE
    au ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE
augroup END

"set background=dark
"if has("gui_vimr")
    "set background=light
"endif

"if getenv("COLORTERM") == "truecolor"
            "\ || getenv("TERM_PROGRAM") == "tmux"
            "\ || getenv("LC_TERMINAL") == "iTerm2"
            "\ || getenv("TERM_PROGRAM") == "vscode"

    "set background=light
    "set notermguicolors
    ""colorscheme onedark
    ""colorscheme base16-atelierdune
    "colorscheme desert

"else
    "set notermguicolors
    "colorscheme desert
"endif

set notermguicolors
set background=light
"colorscheme PaperColor
colorscheme one
