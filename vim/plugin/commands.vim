command Reveals execute 'silent !open -R %:S'
command Code    execute 'silent !open -a "Visual Studio Code.app" %:S'
command Typora  execute 'silent !open -a "Typora.app" %:S'

command! ToggleFoldClose    lua vim.o.foldclose = (vim.o.foldclose == "") and "all" or ""
command! ToggleConcealLevel lua vim.wo.conceallevel = (vim.wo.conceallevel == 0) and 2 or 0

command! -nargs=0 Md2doc !md2doc %

command VimrcEdit tabe ~/.config/nvim/init.vim
command Dos2unix e ++ff=unix | %s/\r//g

" Sshconfig
command Sshconfig tabe ~/.ssh/config
"command Sshconfig tabe ~/code/projects/scripts/ssh.config.json
"au BufWritePost ~/code/projects/scripts/ssh.config.json !update_ssh_config.sh

" shadowsocks config
command Ssconfig tabe ~/.ShadowsocksX/user-rule.txt
au BufWritePost ~/.ShadowsocksX/user-rule.txt !update_ss_config.sh
