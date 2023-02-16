vim.api.nvim_create_user_command('Sshconfig', 'tabe ~/.ssh/config', {})
vim.api.nvim_create_user_command('Reveals', [[execute 'silent !open -R %:S']], {})
vim.api.nvim_create_user_command('Dos2unix', [[e ++ff=unix | %s/\r//g]], {})

--command! ToggleFoldClose    lua vim.o.foldclose = (vim.o.foldclose == "") and "all" or ""
--command! ToggleConcealLevel lua vim.wo.conceallevel = (vim.wo.conceallevel == 0) and 2 or 0
