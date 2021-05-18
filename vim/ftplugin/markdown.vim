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
nmap <buffer> <LocalLeader>b :call ToggleWordWrapWith("**", "**")<CR>
xmap <buffer> <LocalLeader>b :ToggleRangeWrapWith ** **<CR>

" Toggle Italic
nmap <buffer> <LocalLeader>i :call ToggleWordWrapWith("*", "*")<CR>
xmap <buffer> <LocalLeader>i :ToggleRangeWrapWith * *<CR>

" Toggle Inline code
nmap <buffer> <LocalLeader>c :call ToggleWordWrapWith("`", "`")<CR>
xmap <buffer> <LocalLeader>c  :ToggleRangeWrapWith ` `<CR>

" Bold object
xmap <buffer> ab :<C-U>call SelectWrapRange("All", "**", "**")<CR>
xmap <buffer> ib :<C-U>call SelectWrapRange("Inner", "**", "**")<CR>
omap <buffer> ab :<C-U>call SelectWrapRange("All", "**", "**")<CR>
omap <buffer> ib :<C-U>call SelectWrapRange("Inner", "**", "**")<CR>

" Italic object
xmap <buffer> ai :<C-U>call SelectWrapRange("All", "*", "*")<CR>
xmap <buffer> ai :<C-U>call SelectWrapRange("Inner", "*", "*")<CR>
omap <buffer> ai :<C-U>call SelectWrapRange("All", "*", "*")<CR>
omap <buffer> ai :<C-U>call SelectWrapRange("Inner", "*", "*")<CR>

" Italic object
xmap <buffer> ac :<C-U>call SelectWrapRange("All", "`", "`")<CR>
xmap <buffer> ac :<C-U>call SelectWrapRange("Inner", "`", "`")<CR>
omap <buffer> ac :<C-U>call SelectWrapRange("All", "`", "`")<CR>
omap <buffer> ac :<C-U>call SelectWrapRange("Inner", "`", "`")<CR>

function MdUnescape() abort
	%s/\\\([\[\]\.\-\*\~\!\#\_\=\+]\)/\1/g
	%s/  $//ge
	write
endfunction
command! -nargs=0 MdUnescape call MdUnescape()
