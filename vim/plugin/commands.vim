command Reveals execute 'silent !open -R %:S'
command Code    execute 'silent !open -a "Visual Studio Code.app" %:S'

command! ToggleFoldClose    lua vim.o.foldclose = (vim.o.foldclose == "") and "all" or ""
command! ToggleConcealLevel lua vim.wo.conceallevel = (vim.wo.conceallevel == 0) and 2 or 0

command VimrcEdit tabe ~/.config/nvim/init.vim
command Dos2unix e ++ff=unix | %s/\r//g

" Sshconfig
command Sshconfig tabe ~/.ssh/config
