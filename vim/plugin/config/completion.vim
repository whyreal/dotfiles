au BufEnter * lua require'completion'.on_attach()

" vim.g.completion_matching_ignore_case = 1
" vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy', 'all'}
let g:completion_sorting="none"
let g:completion_trigger_keyword_length=2
let g:completion_trigger_on_delete=1
let g:completion_enable_auto_hover=0
let g:completion_auto_change_source=1
let g:completion_matching_smart_case=1
let g:completion_matching_strategy_list=['fuzzy', 'substring']
let g:completion_enable_snippet='vim-vsnip'
let g:completion_confirm_key=""
let g:completion_chain_complete_list=[
			\     {
			\        "complete_items": [
			\            'lsp', 'snippet', 'ts', 'buffers'
			"\            'tabnine',
			"\            'path'
			\        ]
			\     },
			\     {"mode": '<c-p>'},
			\     {"mode": '<c-n>'}
			\ ]
