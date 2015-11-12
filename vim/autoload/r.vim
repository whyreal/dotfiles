function! r#use_my_indent_foldexpr()
    setlocal foldmethod=expr
    setlocal foldexpr=r#indent_foldexpr(v:lnum)
endfunction

function! r#indent_foldexpr(lnum)
    let l:current_indent = indent(a:lnum) / &shiftwidth
    let l:next_indent = indent(a:lnum + 1) / &shiftwidth
    let l:pre_indent = indent(a:lnum - 1) / &shiftwidth

    let l:s = getline(a:lnum)
    if getline(a:lnum) =~ '^\s*$'
        return l:pre_indent > l:next_indent ? l:next_indent : l:pre_indent
    endif

    if l:next_indent > l:current_indent
        return l:next_indent
    elseif l:pre_indent - l:current_indent == 1
        return l:pre_indent
    elseif l:pre_indent - l:current_indent > 1
        if l:current_indent == 0
            return "1"
        else
            return l:current_indent
        endif
    endif

    return l:current_indent
endfunction

function! r#get_foldtext()
    let l:info_len = &textwidth - 20
    let l:info = printf("%." . l:info_len  . "s",
                \substitute(getline(v:foldstart), "[:{}]*\s*$", "", "g"))
    let l:lines = v:foldend - v:foldstart
    return l:info . repeat(" ", &textwidth - len(l:info) - len(l:lines) - 15)
                \. l:lines . " Lines" . "    ----+"
endfunction

function! r#set_default_filetype(filetype)
    if &filetype == ""
        let &l:filetype=a:filetype
    endif
endfunction

function! r#check_dir_exist(name)
    call system('[[ -d ' . a:name . ' ]] || mkdir -p ' . a:name)
endfunction

function! r#toggle_option(name, v1, v2)
    exe "let l:val = &" . a:name 
    if l:val == a:v1
        let l:new_val = a:v2
    else
        let l:new_val = a:v1
    endif
    exe "set " . a:name . "=" . l:new_val
    echo a:name . " --> " . l:new_val
endfunction

function! r#test()
	s/1111/222/g
endfunction
