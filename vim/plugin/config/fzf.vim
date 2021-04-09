let g:fzf_preview_window = ['right:50%:hidden', 'alt-p']

nmap <leader>fm :Marks<CR>
nmap <leader>ff <cmd>lua require("wr.fzfwrapper").files()<CR>
nmap <leader>fb <cmd>lua require("wr.fzfwrapper").buffers()<CR>
nmap <leader>fg <cmd>lua require("wr.fzfwrapper").grep()<CR>
nmap <leader>fw :Windows<CR>
nmap <leader>fc :Commands<CR>
nmap <leader>f/ :History/<CR>
nmap <leader>f; :History:<CR>
nmap <leader>fr :History<CR>
nmap <leader>fl :BLines<CR>

com -nargs=* Rg call luaeval("require[[wr.fzfwrapper]].rg(_A)", shellescape(<q-args>))
