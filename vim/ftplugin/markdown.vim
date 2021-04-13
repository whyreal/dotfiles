"lua require[[wr.ft_markdown]].setup()
set sts=4 tabstop=4 shiftwidth=4
set expandtab
set foldmethod=expr fdl=1 fdls=1

let g:tagbar_sort=0
let g:vim_markdown_no_default_key_mappings=1

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

" Toggle ""
nmap <buffer> <LocalLeader>" <cmd>lua require[[wr.WrappedRange]].toggle_wrap([["]], [["]], false)<CR>
xmap <buffer> <LocalLeader>" :<C-U>lua require[[wr.WrappedRange]].toggle_wrap([["]], [["]], true)<CR>

" Toggle Bold
nmap <buffer> <LocalLeader>b <cmd>lua require[[wr.WrappedRange]].toggle_wrap("**", "**", false)<CR>
xmap <buffer> <LocalLeader>b :<C-U>lua require[[wr.WrappedRange]].toggle_wrap("**", "**", true)<CR>

" Toggle Italic
nmap <buffer> <LocalLeader>i <cmd>lua require[[wr.WrappedRange]].toggle_wrap("*", "*",  false)<CR>
xmap <buffer> <LocalLeader>i :<C-U>lua require[[wr.WrappedRange]].toggle_wrap("*", "*",  true)<CR>

" Toggle Inline code
nmap <buffer> <LocalLeader>c  <cmd>lua require[[wr.WrappedRange]].toggle_wrap("`", "`",  false)<CR>
xmap <buffer> <LocalLeader>c  :<C-U>lua require[[wr.WrappedRange]].toggle_wrap("`", "`",  true)<CR>

" create list
xmap <buffer> <LocalLeader>nl :<C-U>lua require[[wr.Range]]:newFromVisual():mdCreateUnOrderedList()<CR>
xmap <buffer> <LocalLeader>no :<C-U>lua require[[wr.Range]]:newFromVisual():mdCreateOrderedList()<CR>

" delete list
xmap <buffer> <LocalLeader>dl :<C-U>lua require[[wr.Range]]:newFromVisual():mdDeleteList()<CR>

" header
nmap <buffer> <a-[> :<C-U>lua require("wr.Line"):new():headerLevelUp()<CR>
nmap <buffer> <a-]> :<C-U>lua require("wr.Line"):new():headerLevelDown()<CR>
xmap <buffer> <a-[> :<C-U>lua require("wr.Range"):newFromVisual():headerLevelUp()<CR>
xmap <buffer> <a-]> :<C-U>lua require("wr.Range"):newFromVisual():headerLevelDown()<CR>

command -buffer CopyFragLinkW lua require[[wr.Link]]:copyFragLinkW(true)
command -buffer CopyNoFragLinkW lua require[[wr.Link]]:copyFragLinkW()
command -buffer CopyFragLinkB lua require[[wr.Link]]:copyFragLinkB()
command -buffer CopyFragLinkJ lua require[[wr.Link]]:copyJoplinLink(true)
command -buffer CopyNoFragLinkJ lua require[[wr.Link]]:copyJoplinLink(false)

command -buffer -range MDCreateCodeBlockFromeTable lua require("wr.Range"):newFromVisual():mdCreateCodeBlockFromeTable()
command -buffer -range MDCreateCodeBlockFromeCodeLine lua require("wr.Range"):newFromVisual():mdCreateCodeBlockFromeCodeLine()
command -buffer -range MDCreateCodeBlock lua require("wr.Range"):newFromVisual():mdCreateCodeBlock()

" open Link
nmap <buffer> gf gl
nmap <buffer> gl <cmd>lua require[[wr.Link]]:new():open()<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>lua require[[wr.Link]]:new():resolv()<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>lua require[[wr.Link]]:new():copy()<CR>

"augroup update_outline
	"au!
	""au BufWinEnter *.md Voom
	"au BufWinLeave *.md Voomquit
"augroup END
