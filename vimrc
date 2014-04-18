" Neobundle
    if has('vim_starting')
        set nocompatible               " Be iMproved
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    let mapleader = ","

    " Unite Sources
        NeoBundle 'Shougo/unite.vim'
            nnoremap <Space>s :Unite source<CR>
            nnoremap <Space>c :Unite command<CR>
            nnoremap <Space>b :Unite buffer<CR>
            nnoremap <Space>f :Unite file_rec<CR>
            nnoremap <Space>y :Unite history/yank<cr>
            let g:unite_source_history_yank_enable = 1

        NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }
            nnoremap <Space>g :Unite grep:.<CR>

        NeoBundle 'tsukkee/unite-tag'
            nnoremap <Space>t :Unite tag<CR>

        NeoBundle 'h1mesuke/unite-outline'
            nnoremap <Space>o :Unite outline<CR>

        NeoBundle 'tsukkee/unite-help'
            nnoremap <Space>h :Unite help<CR>

        NeoBundle 'Shougo/neomru.vim'
            nnoremap <Space>m :Unite file_mru directory_mru<CR>

    " Edit
        NeoBundle 'vim-scripts/VisIncr'
        NeoBundle 'tpope/vim-surround'
        NeoBundle 'greyblake/vim-preview'
        NeoBundle 'jiangmiao/auto-pairs'

        NeoBundle 'SirVer/ultisnips'
            " Snippets are separated from the engine. Add this if you want them:
            NeoBundle 'honza/vim-snippets'

            " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
            let g:UltiSnipsExpandTrigger="<tab>"
            let g:UltiSnipsJumpForwardTrigger="<c-b>"
            let g:UltiSnipsJumpBackwardTrigger="<c-z>"

            " If you want :UltiSnipsEdit to split your window.
            let g:UltiSnipsEditSplit="vertical"

        NeoBundle 'Shougo/neocomplete.vim'
            " Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
            " Disable AutoComplPop.
            let g:acp_enableAtStartup = 0
            " Use neocomplete.
            let g:neocomplete#enable_at_startup = 1
            " Use smartcase.
            let g:neocomplete#enable_smart_case = 1
            " Set minimum syntax keyword length.
            let g:neocomplete#sources#syntax#min_keyword_length = 3
            let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

            " Define dictionary.
            let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

            " Define keyword.
            if !exists('g:neocomplete#keyword_patterns')
                let g:neocomplete#keyword_patterns = {}
            endif
            let g:neocomplete#keyword_patterns['default'] = '\h\w*'

            " Plugin key-mappings.
            inoremap <expr><C-g>     neocomplete#undo_completion()
            inoremap <expr><C-l>     neocomplete#complete_common_string()

            " Recommended key-mappings.
            " <CR>: close popup and save indent.
            inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
            function! s:my_cr_function()
              return neocomplete#close_popup() . "\<CR>"
              " For no inserting <CR> key.
              "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
            endfunction
            " <TAB>: completion.
            inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
            " <C-h>, <BS>: close popup and delete backword char.
            inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y>  neocomplete#close_popup()
            inoremap <expr><C-e>  neocomplete#cancel_popup()
            " Close popup by <Space>.
            "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

            " For cursor moving in insert mode(Not recommended)
            "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
            "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
            "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
            "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
            " Or set this.
            "let g:neocomplete#enable_cursor_hold_i = 1
            " Or set this.
            "let g:neocomplete#enable_insert_char_pre = 1

            " AutoComplPop like behavior.
            "let g:neocomplete#enable_auto_select = 1

            " Shell like behavior(not recommended).
            "set completeopt+=longest
            "let g:neocomplete#enable_auto_select = 1
            "let g:neocomplete#disable_auto_complete = 1
            "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

            " Enable heavy omni completion.
            if !exists('g:neocomplete#sources#omni#input_patterns')
              let g:neocomplete#sources#omni#input_patterns = {}
            endif
            "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
            "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

            " For perlomni.vim setting.
            " https://github.com/c9s/perlomni.vim
            let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        NeoBundle 'scrooloose/syntastic'
            nnoremap <Leader>s :SyntasticToggleMode<CR>
            "let g:syntastic_mode_map = { 'mode': 'passive'}
            let g:syntastic_error_symbol='✗'
            let g:syntastic_warning_symbol='⚠'
            let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
            let g:syntastic_javascript_checker = 'jshint'

    " syntax
        NeoBundle 'plasticboy/vim-markdown'

    " UI
        NeoBundle 'altercation/vim-colors-solarized'
        NeoBundle 'wesgibbs/vim-irblack'
        NeoBundle 'vim-scripts/mayansmoke'
        NeoBundle 'therubymug/vim-pyte'
        NeoBundle 'vim-scripts/peaksea'

        NeoBundle 'vim-scripts/The-NERD-tree'
            nnoremap <Leader>n :NERDTreeToggle<CR>
            nnoremap <F2> :NERDTreeToggle<CR>
            let g:NERDTreeShowBookmarks = 1

    NeoBundleCheck

    filetype plugin indent on
    syntax on

" Edit
    set tabstop=4
    set shiftwidth=4
    set expandtab        "用空格替换tab, 有效防止python代码中tab/space混用的问题
    set autoindent       "自动缩进

    set pastetoggle=<F11>
    set clipboard=unnamed         " yank and paste with the system clipboard
    set autoread
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

    nnoremap <F1> :tab help <CR>

    " block edit
    nnoremap <F10> :call r#toggle_option("virtualedit", "all", "") <CR>

    nnoremap <F5> :make<CR>
    inoremap <F5> <Esc>:make<CR>
    nnoremap <leader>w :w<CR>
    nnoremap <leader>q :q<CR>
    inoremap jj <Esc>

    " Auto change input method (gui only)
        if has('gui_running')
            set noimdisable
            set iminsert=0
            set imsearch=0
        endif

    " Better Shift
        vnoremap < <gv
        vnoremap > >gv
        nnoremap < <<
        nnoremap > >>

    " Plugings

" Fold
    autocmd Syntax vim,python call r#use_my_indent_foldexpr()

    autocmd Syntax * let &commentstring=" " . &commentstring
    set foldtext=r#get_foldtext()

" Tab
    " Navigation
        nnoremap tf  :tabfirst<CR>
        nnoremap tp  :tabprev<CR>
        nnoremap tn  :tabnext<CR>
        nnoremap tl  :tablast<CR>
        nnoremap tc  :tabnew<CR>
        nnoremap tm  :tabm<Space>
        nnoremap tx  :tabclose<CR>

" Command Line
    "Motion
        cnoremap <C-a>  <Home>
        cnoremap <C-e>  <End>
        cnoremap <C-b>  <C-Left>
        cnoremap <C-f>  <C-Right>
        cnoremap <C-d>  <Delete>

" Ui
    set fillchars=vert:\|
    "set list listchars=tab:»\ ,trail:· "XXXXX
    set hidden
    set textwidth=78
    set cc=+1,+2
    set mouse=a

    if has('gui_running')
        set bg=dark
        let g:solarized_underline=0
        colorscheme solarized
        set macmeta
        set cul
        set guifont=Menlo:h15
        "set transparency=2
        set guioptions-=T
        set guioptions-=R
        set guioptions-=r
        set guioptions-=l
        set guioptions-=L
    elseif $TERM_PROGRAM == "iTerm.app"
        set bg=dark
        set t_Co=256
        "let g:solarized_termcolors=256
        let g:solarized_underline=0
        colorscheme solarized
    else
        colorscheme desert
    endif

    " Split
        set splitbelow
        set splitright

    " Number
        set number
        set relativenumber
        set ruler

    " Status line
        set laststatus=1
        set statusline=%y\ %m%F%=%r\ line:\ %l\ column:\ %c\ %P

" Filetype
    " Default Filetype
    autocmd BufEnter * call r#set_default_filetype("mkd")

" undo/bak/swp file
    " persistent undo
        let s:undo_dir = $HOME . "/.vim/cache/undo"
        if exists('+undofile')
            call r#check_dir_exist(s:undo_dir)
            set undofile
            let &undodir = s:undo_dir
        endif

    " backups
        let s:backup_dir = $HOME . "/.vim/cache/backup"
        call r#check_dir_exist(s:backup_dir)
        set backup
        let &backupdir = s:backup_dir

    " swap files
        let s:swap_dir = $HOME . "/.vim/cache/swap"
        call r#check_dir_exist(s:swap_dir)
        set noswapfile
        let &directory = s:swap_dir

" Search
    set smartcase
    set ignorecase
    set hlsearch
    set incsearch
    set tags=tags;/
    set wildmenu
    set wildmode=full
