func! ProjectComplate(A,L,P)
    return luaeval('require("wr.Project").getProjects()')
endfunc

func! EProject(name)
    call luaeval('require("wr.Project").exploreProject("' . a:name . '")')
endfunc

command -complete=custom,ProjectComplate -nargs=? EProject call EProject(<q-args>)
