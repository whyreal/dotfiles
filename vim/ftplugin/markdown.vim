set sts=4 tabstop=4 shiftwidth=4
set expandtab
set foldmethod=expr fdl=1 fdls=1
set conceallevel=2
set foldclose=all

let g:tagbar_sort=0
let g:vim_markdown_no_default_key_mappings=1

xmap <buffer> <LocalLeader>nl :<C-U>ListCreate<CR>
xmap <buffer> <LocalLeader>no :<C-U>OrderListCreate<CR>
xmap <buffer> <LocalLeader>dl :<C-U>ListDelete<CR>

" header
nmap <buffer> <a-[> :MdHeaderLevelUp<CR>
nmap <buffer> <a-]> :MdHeaderLevelDown<CR>
xmap <buffer> <a-[> :MdHeaderLevelUpRange<CR>
xmap <buffer> <a-]> :MdHeaderLevelDownRange<CR>

" open Link
nmap <buffer> gf gx
nmap <buffer> gx <cmd>OpenURL<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>RevealURL<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>CopyURL<CR>

" Toggle Bold
nmap <buffer> <LocalLeader>b :ToggleWordWrapWithBold<CR>
xmap <buffer> <LocalLeader>b :ToggleRangeWrapWithBold<CR>

" Toggle Italic
nmap <buffer> <LocalLeader>i :ToggleWordWrapWithItalic<CR>
xmap <buffer> <LocalLeader>i :ToggleRangeWrapWithItalic<CR>

" Toggle Inline code
nmap <buffer> <LocalLeader>c  :ToggleWordWrapWithBackquote<CR>
xmap <buffer> <LocalLeader>c  :ToggleRangeWrapWithBackquote<CR>

" Bold object
xmap <buffer> ab :SelectBoldRangeAll<CR>
xmap <buffer> ib :SelectBoldRangeInner<CR>
omap <buffer> ab :SelectBoldRangeAll<CR>
omap <buffer> ib :SelectBoldRangeInner<CR>

" Italic object
xmap <buffer> ai :SelectItalicRangeAll<CR>
xmap <buffer> ii :SelectItalicRangeInner<CR>
omap <buffer> ai :SelectItalicRangeAll<CR>
omap <buffer> ii :SelectItalicRangeInner<CR>

" Italic object
xmap <buffer> ac :SelectBackquoteRangeAll<CR>
xmap <buffer> ic :SelectBoldRangeInner<CR>
omap <buffer> ac :SelectBackquoteRangeAll<CR>
omap <buffer> ic :SelectBoldRangeInner<CR>

command! -nargs=0 MdUnescape lua require[[wr.utils]].markdown_unescape()
