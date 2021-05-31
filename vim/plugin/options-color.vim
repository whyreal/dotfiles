if getenv("TERM_PROGRAM") == "tmux" || getenv("LC_TERMINAL") == "iTerm2"
    set termguicolors
endif

set background=dark
if has("gui_vimr")
    set background=light
endif

colorscheme PaperColor

highlight Normal guibg=NONE
highlight Normal ctermbg=NONE

