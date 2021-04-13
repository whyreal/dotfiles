nmap j gj
nmap k gk

nmap <leader>bp <cmd>bprevious<CR>
nmap <leader>bn <cmd>bnext<CR>
nmap <leader>bd <cmd>bd<CR>
nmap <leader>w  <cmd>w<CR>
nmap <a-=> <cmd>split term://$SHELL<CR>
nmap <leader>bo <c-^>

nmap <leader>ve <cmd>Explore<cr>
tmap <c-o> <c-\><c-n>

nmap 0 <cmd>lua require[[wr.utils]].toggle_home_zero()<CR>

nmap <leader>tt <cmd>lua require[[wr.Line]]:new():sendToTmux()<CR>
xmap <leader>tt :<C-U>lua require[[wr.Range]]:newFromVisual():sendVisualToTmux()<CR>

