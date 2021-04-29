let g:netrw_winsize = 30
" 0 keep the current directory the same as the browsing directory.
"let g:netrw_keepdir=0

"let g:netrw_bookmarklist = "[$PWD]"
"let g:netrw_browsex_viewer = '-'

let g:netrw_sort_options="i"
let g:netrw_nogx = 1

highlight link netrwMarkFile Visual

" NFH_suffix(filename)
fun! NFH_md(filename)
	echomsg(a:filename)
endfun
