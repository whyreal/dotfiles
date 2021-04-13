func! ProjectComplate(A,L,P)
    return join(keys(g:projects), "\n")
endfunc

func! EProject(name)
    execute "Explore " . g:projects[a:name]
endfunc

command -complete=custom,ProjectComplate -nargs=? EProject call EProject(<q-args>)
