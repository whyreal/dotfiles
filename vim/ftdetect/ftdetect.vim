au BufNewFile,BufRead *.rest,*.http set filetype=rest
au BufNewFile,BufRead *.json   set filetype=jsonc
au BufNewFile,BufRead *.tsx    set filetype=typescript.tsx
au BufNewFile,BufRead *.jsx    set filetype=javascript.jsx
au BufNewFile,BufRead *.docker set filetype=Dockerfile
au BufNewFile,BufRead *.fish   set filetype=fish
au BufNewFile,BufRead */nginx/*.conf   set filetype=nginx

au FileType javascript,
            \typescript,
            \javascript.jsx,
            \typescript.tsx,
            \json,
            \jsonc,
            \vue,
            \jsp,
            \xml,
            \html,
            \css
            \ setlocal sts=2 ts=2 sw=2 fdm=indent
