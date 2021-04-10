let g:vsnip_snippet_dir=getenv("HOME") .. "/.config/nvim/snippets"
imap <expr> <CR>    v:lua.imap.cr()
imap <expr> <TAB>   v:lua.imap.tab()
imap <expr> <S-TAB> v:lua.imap.stab()
smap <expr> <TAB>   v:lua.smap.tab()
smap <expr> <S-TAB> v:lua.smap.stab()
