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

command Preview  execute 'silent !open -a "Typora.app" %:S'
command Typora  execute 'silent !open -a "Typora.app" %:S'
command Edge  execute 'silent !open -a "Microsoft Edge.app" %:S'

command! -nargs=0 Md2doc !md2doc %

let b:fenced_block = 0
let b:front_matter = 0
let s:vim_markdown_folding_level = get(g:, "vim_markdown_folding_level", 1)

function! s:is_mkdCode(lnum)
    let name = synIDattr(synID(a:lnum, 1, 0), 'name')
    return (name =~ '^markdown\%(Code$\|Snippet\)' || name != '' && name !~ '^\%(markdown\|html\)')
endfunction

function! Foldexpr_markdown(lnum)
    let l1 = getline(a:lnum)
    "~~~~~ keep track of fenced code blocks ~~~~~
    "If we hit a code block fence
    if l1 =~ '````*' || l1 =~ '\~\~\~\~*'
        " toggle the variable that says if we're in a code block
        if b:fenced_block == 0
            let b:fenced_block = 1
        elseif b:fenced_block == 1
            let b:fenced_block = 0
        endif
    " else, if we're caring about front matter
    elseif g:vim_markdown_frontmatter == 1
        " if we're in front matter and not on line 1
        if b:front_matter == 1 && a:lnum > 2
            let l0 = getline(a:lnum-1)
            " if the previous line fenced front matter
            if l0 == '---'
                " we must not be in front matter
                let b:front_matter = 0
            endif
        " else, if we're on line one
        elseif a:lnum == 1
            " if we hit a front matter fence
            if l1 == '---'
                " we're in the front matter
                let b:front_matter = 1
            endif
        endif
    endif

    " if we're in a code block or front matter
    if b:fenced_block == 1 || b:front_matter == 1
        if a:lnum == 1
            " fold any 'preamble'
            return '>1'
        else
            " keep previous foldlevel
            return '='
        endif
    endif

    let l2 = getline(a:lnum+1)
    " if the next line starts with two or more '='
    " and is not code
    if l2 =~ '^==\+\s*' && !s:is_mkdCode(a:lnum+1)
        " next line is underlined (level 1)
        return '>0'
    " else, if the nex line starts with two or more '-'
    " and is not code
    elseif l2 =~ '^--\+\s*' && !s:is_mkdCode(a:lnum+1)
        " next line is underlined (level 2)
        return '>1'
    endif

    "if we're on a non-code line starting with a pound sign
    if l1 =~ '^#' && !s:is_mkdCode(a:lnum)
        " set the fold level to the number of hashes -1
        " return '>'.(matchend(l1, '^#\+') - 1)
        " set the fold level to the number of hashes
        return '>'.(matchend(l1, '^#\+'))
    " else, if we're on line 1
    elseif a:lnum == 1
        " fold any 'preamble'
        return '>1'
    else
        " keep previous foldlevel
        return '='
    endif
endfunction

function! Foldtext_markdown()
    let line = getline(v:foldstart)
    let has_numbers = &number || &relativenumber
    let nucolwidth = &fdc + has_numbers * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 6
    let foldedlinecount = v:foldend - v:foldstart
    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let line = substitute(line, '\%("""\|''''''\)', '', '')
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) + 1
    return line . ' ' . repeat("-", fillcharcount) . ' ' . foldedlinecount
endfunction

setlocal foldtext=Foldtext_markdown()
setlocal foldexpr=Foldexpr_markdown(v:lnum)
