augroup clean_bg
    au!
    au ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    au ColorScheme * highlight NonText guibg=NONE ctermbg=NONE
    au ColorScheme * highlight LineNr guibg=NONE ctermbg=NONE
    au ColorScheme * highlight Folded guibg=NONE ctermbg=NONE
    au ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE
    " fix coc float win color"
    au ColorScheme * highlight! link FgCocInfoFloatBgCocFloating NormalFloat 
augroup END

if has("gui_vimr")
    set background=light
    colorscheme onehalflight 
    finish
endif

if getenv("LC_TERMINAL") == "iTerm2"
    set termguicolors
    set background=dark
    colorscheme PaperColor
    finish
endif

if getenv("TERMAPP") == "vscode"
    set background=light
    colorscheme github_light
    finish
endif

if getenv("TERMAPP") == "alacritty"
    set termguicolors
    set background=dark
    colorscheme PaperColor
    finish
endif

if getenv("TERM_PROGRAM") == "tmux"
    set background=dark
    colorscheme PaperColor
"    set termguicolors
    finish
endif

" default
set background=dark
colorscheme PaperColor
