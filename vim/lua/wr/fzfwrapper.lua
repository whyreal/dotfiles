local fzfwrapper = {}

fzfwrapper.files = function()
    vim.fn['fzf#vim#files']("", {options = {
                                    '--history=' .. vim.env.HOME .. '/.fzf.history',
                                    '--preview', 'cat {}',
                                    '--preview-window', 'right:50%:hidden',
                                    '--bind=alt-c:execute(cp_file2clipboard.sh {})+abort',
                                    '--bind=alt-o:execute(open {})+abort',
                                    '--bind=alt-r:execute(open -R {})+abort',
                                    '--bind=alt-p:toggle-preview',
                                    '--info=inline'}}, false)
end

fzfwrapper.buffers = function()
    vim.fn['fzf#vim#buffers']("", {options = {
                                    '--history=' .. vim.env.HOME .. '/.fzf.history',
                                    '--bind=alt-c:execute(cp_file2clipboard.sh {4})+abort',
                                    '--bind=alt-o:execute(eval open {4})+abort',
                                    '--bind=alt-r:execute(eval open -R {4})+abort',
                                    '--header-lines=0',
                                    '--info=inline'}}, false)
end

fzfwrapper.rg = function (arg)
	local cmd = 'rg -L --column --line-number --no-heading --color=always --smart-case -- ' .. arg
	vim.fn['fzf#vim#grep'](cmd, 1, vim.fn['fzf#vim#with_preview'](), 0)
end

return fzfwrapper