au FileType jsp,xml,html,css setlocal sts=2 ts=2 sw=2
au FileType javascript,typescript.tsx,json,jsonc setlocal sts=2 ts=2 sw=2

au BufNewFile,BufRead *.json   set filetype=jsonc
au BufNewFile,BufRead *.tsx    set filetype=typescript.tsx
au BufNewFile,BufRead *.jsx    set filetype=javascript.jsx
au BufNewFile,BufRead *.docker set filetype=Dockerfile
au BufNewFile,BufRead *.fish set filetype=fish
