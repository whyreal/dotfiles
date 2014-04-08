" Neobundle
    if has('vim_starting')
        set nocompatible               " Be iMproved
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    let mapleader = ","

    " Plugings
        " unite sources
        NeoBundle 'Shougo/unite.vim'
            nnoremap <C-p> :Unite source<CR>
            nnoremap <space>c :Unite command<CR>
            nnoremap <space>b :Unite buffer<CR>
            nnoremap <space>f :Unite file_rec<CR>
            nnoremap <space>y :Unite history/yank<cr>
                let g:unite_source_history_yank_enable = 1
        NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }
            nnoremap <space>g :Unite grep:.<CR>
        NeoBundle 'tsukkee/unite-tag'
            nnoremap <space>t :Unite tag<CR>
        NeoBundle 'h1mesuke/unite-outline'
        NeoBundle 'tsukkee/unite-help'
            nnoremap <space>h :Unite help<CR>
        NeoBundle 'Shougo/neomru.vim'
            nnoremap <space>m :Unite file_mru directory_mru<CR>

        " colorscheme
        NeoBundle 'altercation/vim-colors-solarized'
        NeoBundle 'wesgibbs/vim-irblack'
        NeoBundle 'vim-scripts/mayansmoke'
        NeoBundle 'therubymug/vim-pyte'
        NeoBundle 'vim-scripts/peaksea'

        " syntax
        NeoBundle 'plasticboy/vim-markdown'
        NeoBundle 'greyblake/vim-preview'
        NeoBundle 'scrooloose/syntastic'
            nnoremap <Leader>s :SyntasticToggleMode<CR>
            "let g:syntastic_mode_map = { 'mode': 'passive'}
            let g:syntastic_error_symbol='✗'
            let g:syntastic_warning_symbol='⚠'
            let g:syntastic_javascript_jshint_conf = "--config /Users/real/.jshint.json"
            let g:syntastic_javascript_checker = 'jshint'

        " autocomplete
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

        " navigation
        NeoBundle 'vim-scripts/The-NERD-tree'
            nnoremap <Leader>n :NERDTreeToggle<CR>
            let g:NERDTreeShowBookmarks = 1

        NeoBundle 'vim-scripts/VisIncr'
        NeoBundle 'tpope/vim-surround'

        NeoBundleCheck

    filetype plugin indent on
    syntax on

" Ui
    " split
    set splitbelow
    set splitright
    " nu
    set number
    set relativenumber
    set fillchars=vert:\|
    set list listchars=tab:»\ ,trail:· "XXXXX
    set hidden
    set list listchars=tab:»\ ,trail:·
    set laststatus=2
    set statusline=%y\ %m%F%=%r\ line:\ %l\ column:\ %c\ %P
    set cc=80
    set mouse=a

    if has('gui_running')
        set bg=light
        colorscheme solarized
        set cul
        set guifont=Menlo:h15
        "set transparency=2
        set guioptions-=T  "关闭菜单, 滚动条等UI元素
        set guioptions-=R
        set guioptions-=r
        set guioptions-=l
        set guioptions-=L
    else
        set bg=dark
        let g:solarized_termcolors=256
        set t_Co=256
        colorscheme desert
    endif

" Edit
    set tabstop=4
    set shiftwidth=4
    set expandtab        "用空格替换tab, 有效防止python代码中tab/space混用的问题
    set autoindent       "自动缩进

    set pastetoggle=<F11>         " 粘贴开关
    set clipboard=unnamed         " yank and paste with the system clipboard
    set autoread
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

    " Filetype
        " default filetype
        autocmd BufEnter * if &filetype == "" | setlocal ft=mkd | endif

        "autocmd Syntax c,cpp,xml,html,xhtml setlocal foldmethod=syntax
        "autocmd Syntax c,cpp,vim,xml,html,xhtml,perl normal zR
        autocmd Syntax vim,python setlocal foldmethod=indent

    " Im
        set noimdisable
        set iminsert=0
        set imsearch=0

    " Map
        nnoremap <leader>w :w<CR>
        nnoremap <leader>q :q<CR>

        vnoremap < <gv
        vnoremap > >gv
        nnoremap < <<
        nnoremap > >>

    " undo/bak/swp
        " persistent undo
        if exists('+undofile')
          set undofile
          set undodir=/tmp/.vimcache/undo
        endif

        " backups
        set backup
        set backupdir=/tmp/.vimcache/backup

        " swap files
        set directory=/tmp/.vimcache/swap
        set noswapfile

    " Search
        set smartcase
        set ignorecase
        set hlsearch
        set incsearch
        set tags=tags;/
        set wildmenu
        set wildmode=full
    " tab navigation
        nnoremap th  :tabfirst<CR>
        nnoremap tj  :tabprev<CR>
        nnoremap tk  :tabnext<CR>
        nnoremap tl  :tablast<CR>
        nnoremap tn  :tabnew<CR>
        nnoremap tm  :tabm<Space>
        nnoremap tc  :tabclose<CR>
        " Alternatively use
        " "nnoremap th :tabnext<CR>
        " "nnoremap tl :tabprev<CR>
        " "nnoremap tn :tabnew<CR>

" vim: foldmethod=indent
