" Neobundle
    if has('vim_starting')
        set nocompatible               " Be iMproved
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    let mapleader = ","

    " Plugings
        NeoBundle 'Shougo/unite.vim'
            nnoremap <leader>b :Unite buffer<CR>
            nnoremap <leader>f :Unite file<CR>

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

        NeoBundle 'SirVer/ultisnips'
            " Snippets are separated from the engine. Add this if you want them:
            NeoBundle 'honza/vim-snippets'

            " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
            let g:UltiSnipsExpandTrigger="<tab>"
            let g:UltiSnipsJumpForwardTrigger="<c-b>"
            let g:UltiSnipsJumpBackwardTrigger="<c-z>"

            " If you want :UltiSnipsEdit to split your window.
            let g:UltiSnipsEditSplit="vertical"

        NeoBundle 'vim-scripts/The-NERD-tree'
            nnoremap <Leader>t :NERDTreeToggle<CR>
            let g:NERDTreeShowBookmarks = 1

        NeoBundle 'plasticboy/vim-markdown'

    " unite-tag
        NeoBundle 'tsukkee/unite-tag'

    " unite-outline
        NeoBundle 'h1mesuke/unite-outline'

    " unite-help
        NeoBundle 'tsukkee/unite-help'

    filetype plugin indent on
    syntax on

    NeoBundleCheck

" Ui
    set t_Co=256 
    set fillchars=vert:\|,fold:\ 
    set list listchars=tab:»\ ,trail:·

    " split
    set splitbelow
    set splitright

    " nu
    set number
    set relativenumber

    set background=dark
    colorscheme desert

    if has('gui_running')
        colorscheme solarized
        set mouse=a
        set cul
        set mouse=a
        set guifont=Menlo:h14
        set transparency=2
        set guioptions-=T  "关闭菜单, 滚动条等UI元素
        set guioptions-=R
        set guioptions-=r
        set guioptions-=l
        set guioptions-=L
    endif

    set foldmethod=indent

    set hidden

" Edit
    set tabstop=4
    set shiftwidth=4
    set autoindent       "自动缩进
    set expandtab        "用空格替换tab, 有效防止python代码中tab/space混用的问题
    set pastetoggle=<F11>         " 粘贴开关
    set clipboard=unnamed         " yank and paste with the system clipboard
    set autoread
    set autochdir
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
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
