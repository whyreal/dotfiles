nmap <silent> <F5> :call MarkdownPreview()<CR>
function! MarkdownPreview ()
    w! /tmp/markdown_preview
    !~/.vim/scripts/md_preview.sh /tmp/markdown_preview
endfunction
