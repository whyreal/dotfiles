" Use better keys for the bépo keyboard layout and set
" a balanced distribution of terminal / sequence keys
lua require'hop'.setup { keys = 'etovxdygfblzhckisuran', jump_on_sole_occurrence = false }

noremap fw <cmd>HopWord<CR>
noremap fp <cmd>HopPattern<CR>
"noremap fc <cmd>HopChar1
noremap fc <cmd>HopChar2<CR>
noremap fl <cmd>HopLine<CR>
"noremap fl <cmd>HopLineStart<CR>
