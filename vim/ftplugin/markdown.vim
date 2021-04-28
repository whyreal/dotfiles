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

" open Link
nmap <buffer> gf gx
nmap <buffer> gx <cmd>OpenURL<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>RevealURL<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>lua S.link.copy()<CR>

" header
nmap <buffer> <a-[> :MdHeaderLevelUp<CR>
nmap <buffer> <a-]> :MdHeaderLevelDown<CR>
xmap <buffer> <a-[> :<C-U>MdHeaderLevelUpRange<CR>
xmap <buffer> <a-]> :<C-U>MdHeaderLevelDownRange<CR>

command -buffer CopyFragLinkW lua require[[wr.Link]]:copyFragLinkW(true)
command -buffer CopyNoFragLinkW lua require[[wr.Link]]:copyFragLinkW()
command -buffer CopyFragLinkB lua require[[wr.Link]]:copyFragLinkB()
command -buffer CopyFragLinkJ lua require[[wr.Link]]:copyJoplinLink(true)
command -buffer CopyNoFragLinkJ lua require[[wr.Link]]:copyJoplinLink(false)

" Toggle quote(")
nmap <buffer> <LocalLeader>" <cmd>lua S.markdown.toggleQuoteByWord()<CR>
xmap <buffer> <LocalLeader>" :<C-U>lua S.markdown.addQuoteByVisual()<CR>

" Toggle Bold
nmap <buffer> <LocalLeader>b <cmd>lua S.markdown.toggleBoldByWord()<CR>
xmap <buffer> <LocalLeader>b :<C-U>lua S.markdown.addBoldByVisual()<CR>

" Toggle Italic
nmap <buffer> <LocalLeader>i <cmd>lua S.markdown.toggleItalicByWord()<CR>
xmap <buffer> <LocalLeader>i :<C-U>lua S.markdown.addItalicByVisual()<CR>

" Toggle Inline code
nmap <buffer> <LocalLeader>c  <cmd>lua S.markdown.toggleInlineCodeByWord()<CR>
xmap <buffer> <LocalLeader>c  :<C-U>lua S.markdown.addInlineCodeByVisual()<CR>

" Bold object
xmap <buffer> ab :<C-U>lua require[[wr.WrappedRange]]:newFromSep("**", "**"):select_all()<CR>
xmap <buffer> ib :<C-U>lua require[[wr.WrappedRange]]:newFromSep("**", "**"):select_inner()<CR>
omap <buffer> ab :<C-U>lua require[[wr.WrappedRange]]:newFromSep("**", "**"):select_all()<CR>
omap <buffer> ib :<C-U>lua require[[wr.WrappedRange]]:newFromSep("**", "**"):select_inner()<CR>

" Italic object
xmap <buffer> ai :<C-U>lua require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_all()<CR>
xmap <buffer> ii :<C-U>lua require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_inner()<CR>
omap <buffer> ai :<C-U>lua require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_all()<CR>
omap <buffer> ii :<C-U>lua require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_inner()<CR>

command! -nargs=0 MdUnescape lua require[[wr.utils]].markdown_unescape()

