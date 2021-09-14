set sts=4 tabstop=4 shiftwidth=4
set expandtab
set foldmethod=expr fdl=1 fdls=1
"set conceallevel=2
set foldclose=all

"au ColorScheme *.md highlight! link htmlBold Search

let g:tagbar_sort=0
let g:vim_markdown_no_default_key_mappings=1

xmap <buffer> <LocalLeader>nl <Plug>(coc-markdown-create-list)
xmap <buffer> <LocalLeader>no <Plug>(coc-markdown-create-orderlist)
xmap <buffer> <LocalLeader>dl <Plug>(coc-markdown-delete-list)

" header
nmap <buffer> <a-[> <Plug>(coc-markdown-header-level-up)
nmap <buffer> <a-]> <Plug>(coc-markdown-header-level-down)
xmap <buffer> <a-[> <Plug>(coc-markdown-header-level-up-range)
xmap <buffer> <a-]> <Plug>(coc-markdown-header-level-down-range)

" open Link
nmap <buffer> gf gx
nmap <buffer> gx <cmd>CocCommand OpenURL<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>CocCommand RevealURL<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>CocCommand CopyURL<CR>

" Toggle Bold
nmap <buffer> <LocalLeader>b <Plug>(coc-wrap-bold-word)
vmap <buffer> <LocalLeader>b <Plug>(coc-wrap-bold-range)

" Toggle strike through
nmap <buffer> <LocalLeader>s <Plug>(coc-wrap-strikethrough-word)
xmap <buffer> <LocalLeader>s <Plug>(coc-wrap-strikethrough-range)

" Toggle Italic
nmap <buffer> <LocalLeader>i <Plug>(coc-wrap-italic-word)
xmap <buffer> <LocalLeader>i <Plug>(coc-wrap-italic-range)

" Toggle Inline code
nmap <buffer> <LocalLeader>c <Plug>(coc-wrap-code-word)
xmap <buffer> <LocalLeader>c <Plug>(coc-wrap-code-range)

" Bold object
xmap <buffer> ab <Plug>(coc-v-range-select-bold-all)
xmap <buffer> ib <Plug>(coc-v-range-select-bold-inner)
omap <buffer> ab <Plug>(coc-o-range-select-bold-all)
omap <buffer> ib <Plug>(coc-o-range-select-bold-inner)

" Italic object
xmap <buffer> ai <Plug>(coc-v-range-select-italic-all)
xmap <buffer> ii <Plug>(coc-v-range-select-italic-inner)
omap <buffer> ai <Plug>(coc-o-range-select-italic-all)
omap <buffer> ii <Plug>(coc-o-range-select-italic-inner)

" code object
xmap <buffer> ac <Plug>(coc-v-range-select-code-all)
xmap <buffer> ic <Plug>(coc-v-range-select-code-inner)
omap <buffer> ac <Plug>(coc-o-range-select-code-all)
omap <buffer> ic <Plug>(coc-o-range-select-code-inner)

" strikethrough object
xmap <buffer> as <Plug>(coc-v-range-select-strikethrough-all)
xmap <buffer> is <Plug>(coc-v-range-select-strikethrough-inner)
omap <buffer> as <Plug>(coc-o-range-select-strikethrough-all)
omap <buffer> is <Plug>(coc-o-range-select-strikethrough-inner)

command Typora  execute 'silent !open -a "Typora.app" %:S'
command! -nargs=0 Md2doc !md2doc %

function MdUnescape() abort
	%s/\\\([\[\]\.\-\*\~\!\#\_\=\+]\)/\1/g
	%s/  $//ge
	write
endfunction
command! -nargs=0 MdUnescape call MdUnescape()

function DeleteBlankLine(l1, l2) abort
    execute a:l1 . "," . a:l2 . "g/^ *$/d"
	write
endfunction
command! -nargs=0 -range DeleteBlankLine call DeleteBlankLine(<line1>, <line2>)

function DeleteTailBlankSpace(l1, l2) abort
    execute a:l1 . "," . a:l2 . "s/  *$//g"
	write
endfunction

command! -nargs=0 -range=% DeleteTailBlankSpace call DeleteTailBlankSpace(<line1>, <line2>)
