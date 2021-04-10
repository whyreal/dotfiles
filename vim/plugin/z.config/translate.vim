let g:translator_default_engines=['bing', 'google']
let g:translator_history_enable="true"
"-- Echo translation in the cmdline
nmap <leader>tc <Plug>Translate
vmap <leader>tc <Plug>TranslateV
"-- Display translation in a window
nmap <leader>tw <Plug>TranslateW
vmap <leader>tw <Plug>TranslateWV
nmap <LocalLeader>w <Plug>TranslateW
vmap <LocalLeader>w <Plug>TranslateWV
"-- Replace the text with translation
nmap '<leader>tr <Plug>TranslateR
vmap '<leader>tr <Plug>TranslateRV
"-- Translate the text in clipboard
xmap '<leader>x <Plug>TranslateX
