" always display all buffers
let g:airline#extensions#tabline#enabled = 1

" display file name only
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 在顶部显示状态栏
"let g:airline_statusline_ontop=1

" 定制状态栏内容
    "let g:airline_section_a       (mode, crypt, paste, spell, iminsert)
    "let g:airline_section_a = ''
    "let g:airline_section_c       (bufferline or filename, readonly)
    "let g:airline_section_c = ''
    "let g:airline_section_x       (tagbar, filetype, virtualenv)

" Detection
    " enable modified detection
    let g:airline_detect_modified=0
    " enable paste detection
    let g:airline_detect_paste=0
    " enable crypt detection
    let g:airline_detect_crypt=0
    " enable spell detection
    let g:airline_detect_spell=0
    " display spelling language when spell detection is enabled
    let g:airline_detect_spelllang=0
    " enable iminsert detection >
    let g:airline_detect_iminsert=0
    " enable/disable detection of whitespace errors.
    let g:airline#extensions#whitespace#enabled = 0
