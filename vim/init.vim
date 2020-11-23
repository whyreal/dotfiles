if has('nvim')
	lua require('wr')

	command! -bang -nargs=? -complete=dir Files
				\ call fzf#vim#files(<q-args>, {'options': [
				\ '--preview', 'cat {}',
				\ '--preview-window', 'right:50%:hidden',
				\ '--bind=alt-o:execute(open {})+abort,alt-r:execute(open -R {})+abort,alt-p:toggle-preview',
				\ '--info=inline']}, <bang>0)
endif

" vim: fdm=marker
