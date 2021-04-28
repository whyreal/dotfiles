nmap j gj
nmap k gk
xmap j gj
xmap k gk
imap kk <ESC>

nmap <leader>bp <cmd>bprevious<CR>
nmap <leader>bn <cmd>bnext<CR>
nmap <leader>bd <cmd>bd<CR>
nmap <leader>w  <cmd>w<CR>
nmap <a-=> <cmd>split term://$SHELL<CR>
nmap <leader>bo <c-^>

nmap <leader>ve <cmd>Explore<cr>
tmap <c-o> <c-\><c-n>

nmap 0 <cmd>GotoFirstChar<CR>

nmap <leader>tt <cmd>CmdSendLine<CR>
xmap <leader>tt <cmd>CmdSendRange<CR>

" open Link
nmap <buffer> gf gx
nmap <buffer> gx <cmd>OpenURL<CR>
" resolv file in Finder
nmap <buffer> gr <cmd>RevealURL<CR>
" copy id (joplin) or path (local , path ...)
nmap <buffer> gy <cmd>CopyURL<CR>

