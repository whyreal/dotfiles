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

if getenv("TERM_PROGRAM") == "tmux"
    set background=light
    colorscheme onehalflight
    set termguicolors
    finish
endif

if has("gui_vimr")
    set background=light
    colorscheme onehalflight 
    finish
endif

if getenv("LC_TERMINAL") == "iTerm2"
    set background=light
    colorscheme onehalflight
    set termguicolors
    finish
endif

if getenv("TERM_PROGRAM") == "vscode"
    set background=light
    colorscheme github_light
    finish
endif

" default
set background=light
colorscheme onehalflight
