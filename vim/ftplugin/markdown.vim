set sts=4 tabstop=4 shiftwidth=4
set expandtab
set foldmethod=expr fdl=1 fdls=1
set conceallevel=2
set foldclose=all

let g:tagbar_sort=0
let g:vim_markdown_no_default_key_mappings=1

" create list
xmap <buffer> <LocalLeader>nl :<C-U>lua S.markdown.createUnOrderedList()<CR>
xmap <buffer> <LocalLeader>no :<C-U>lua S.markdown.createOrderedList()<CR>

" delete list
xmap <buffer> <LocalLeader>dl :<C-U>lua S.markdown.deleteList()<CR>

" header
nmap <buffer> <a-[> :<C-U>lua S.markdown.headerLevelUp()<CR>
nmap <buffer> <a-]> :<C-U>lua S.markdown.headerLevelDown()<CR>
xmap <buffer> <a-[> :<C-U>lua S.markdown.multiHeaderLevelUp()<CR>
xmap <buffer> <a-]> :<C-U>lua S.markdown.multiHeaderLevelDown()<CR>

" Toggle
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

command -buffer -range MDCreateCodeBlock lua S.markdown.createCodeBlock()
command -buffer -range MDCreateCodeBlockFromeTable lua S.markdown.createCodeBlockFromeTable()
command -buffer -range MDCreateCodeBlockFromeCodeLine lua S.markdown.createCodeBlockFromeCodeLine()

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

command -buffer CopyFragLinkW lua require[[wr.Link]]:copyFragLinkW(true)
command -buffer CopyNoFragLinkW lua require[[wr.Link]]:copyFragLinkW()
command -buffer CopyFragLinkB lua require[[wr.Link]]:copyFragLinkB()
command -buffer CopyFragLinkJ lua require[[wr.Link]]:copyJoplinLink(true)
command -buffer CopyNoFragLinkJ lua require[[wr.Link]]:copyJoplinLink(false)


" open Link
nmap <buffer> gf gl
nmap <buffer> gl <cmd>lua S.link.open()<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>lua S.link.resolv()<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>lua S.link.copy()<CR>

"augroup update_outline
	"au!
	""au BufWinEnter *.md Voom
	"au BufWinLeave *.md Voomquit
"augroup END
