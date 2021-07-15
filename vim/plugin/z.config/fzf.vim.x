let g:fzf_preview_window = ['right:50%:hidden', 'alt-p']

nmap <leader>fm :Marks<CR>
nmap <leader>ff :Files<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fg :Rg 
nmap <leader>fw :Windows<CR>
nmap <leader>fc :Commands<CR>
nmap <leader>f/ :History/<CR>
nmap <leader>f; :History:<CR>
nmap <leader>fr :History<CR>
nmap <leader>fl :BLines<CR>

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': [
            \ '--history=' . getenv("HOME") . '/.fzf.history',
            \ '--preview', 'cat {}',
		    \ '--preview-window', 'right:50%:hidden',
		    \ '--bind=alt-o:execute(open {})+abort',
		    \ '--bind=alt-r:execute(open -R {})+abort',
		    \ '--bind=alt-y:execute(realpath {} | pbcopy)+abort',
		    \ '--bind=alt-p:toggle-preview',
		    \ '--info=inline']}, <bang>0)


command! -bang -nargs=? Buffers
        \ call fzf#vim#buffers(<q-args>, {'options': [
            \ '--history=' . getenv("HOME") . '/.fzf.history',
            \ '--bind=alt-c:execute(cp_file2clipboard.sh {4})+abort',
            \ '--bind=alt-o:execute(eval open {4})+abort',
            \ '--bind=alt-r:execute(eval open -R {4})+abort',
            \ '--header-lines=0',
            \ '--info=inline']}, <bang>0)

command! -bang -nargs=? Rg
        \ call fzf#vim#grep('rg -L --column --line-number --no-heading '
        \ . '--color=always --smart-case -- ' . <q-args>,
        \ 1, fzf#vim#with_preview(), 0)
