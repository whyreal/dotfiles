set rtp+=/usr/local/opt/fzf

if has('nvim')

    lua require('wr')

    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>, {'options': [
                \ '--preview', 'cat {}',
                \ '--preview-window', 'right:50%:hidden',
                \ '--bind=alt-c:execute(cp_file2clipboard.sh {})+abort',
				\ '--bind=alt-o:execute(open {})+abort',
				\ '--bind=alt-r:execute(open -R {})+abort',
				\ '--bind=alt-p:toggle-preview',
                \ '--info=inline']}, <bang>0)

    command! -bang -nargs=? -complete=dir Buffers
				\ call fzf#vim#buffers(<q-args>, {'options': [
				\ '--bind=alt-c:execute(cp_file2clipboard.sh {4})+abort',
				\ '--bind=alt-o:execute(eval open {4})+abort',
				\ '--bind=alt-r:execute(eval open -R {4})+abort',
				\ '--header-lines=0',
				\ '--info=inline']}, <bang>0)
endif

let g:fzf_preview_window = ['right:50%:hidden', 'alt-p']

" vim: fdm=marker
