local M = {}

M.setup = function ()

	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.wo.foldmethod = 'expr'

	vim.g.tagbar_sort = 0

	vim.g.vim_markdown_no_default_key_mappings = 1

	-- Bold object
	wr.map_norange_lua('v', 'ab', 'WrappedRange:newFromSep("**", "**"):select_all()',   {buffer = true})
	wr.map_norange_lua('v', 'ib', 'WrappedRange:newFromSep("**", "**"):select_inner()', {buffer = true})
	wr.map_norange_lua('o', 'ab', 'WrappedRange:newFromSep("**", "**"):select_all()',   {buffer = true})
	wr.map_norange_lua('o', 'ib', 'WrappedRange:newFromSep("**", "**"):select_inner()', {buffer = true})

	-- Italic object
	wr.map_norange_lua('v', 'ai', 'WrappedRange:newFromSep("*",  "*"):select_all()',    {buffer = true})
	wr.map_norange_lua('v', 'ii', 'WrappedRange:newFromSep("*",  "*"):select_inner()',  {buffer = true})
	wr.map_norange_lua('o', 'ai', 'WrappedRange:newFromSep("*",  "*"):select_all()',    {buffer = true})
	wr.map_norange_lua('o', 'ii', 'WrappedRange:newFromSep("*",  "*"):select_inner()',  {buffer = true})

	-- Toggle Bold
	wr.maplua('n',          '<LocalLeader>b',  'WrappedRange.toggle_wrap("**", "**", false)', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>b',  'WrappedRange.toggle_wrap("**", "**", true)',  {buffer = true})

	-- Toggle Italic
	wr.maplua('n',          '<LocalLeader>i',  'WrappedRange.toggle_wrap("*", "*",  false)', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>i',  'WrappedRange.toggle_wrap("*", "*",  true)',  {buffer = true})

	-- Toggle Inline code
	wr.maplua('n',          '<LocalLeader>c',  'WrappedRange.toggle_wrap("`", "`",  false)', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>c',  'WrappedRange.toggle_wrap("`", "`",  true)',  {buffer = true})

	-- create list
	wr.map_norange_lua('v', '<LocalLeader>nl', 'Range:newFromVisual():make_list()',         {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>no', 'Range:newFromVisual():make_ordered_list()', {buffer = true})

	-- delete list
	wr.map_norange_lua('v', '<LocalLeader>dl', 'Range:newFromVisual():remove_list()', {buffer = true})

	-- preview
	wr.mapcmd('n', '<LocalLeader>p', 'ComposerOpen', {buffer = true})

	-- Link object
	wr.map_norange_lua('v', 'al', 'WrappedRange:newFromSep("[",  ")"):select_all()',    {buffer = true})
	wr.map_norange_lua('v', 'il', 'WrappedRange:newFromSep("[",  ")"):select_inner()',  {buffer = true})
	wr.map_norange_lua('o', 'al', 'WrappedRange:newFromSep("[",  ")"):select_all()',    {buffer = true})
	wr.map_norange_lua('o', 'il', 'WrappedRange:newFromSep("[",  ")"):select_inner()',  {buffer = true})

    -- Follow Link
    wr.maplua('n', 'gx', 'Link:new():open()', {buffer = true})
    wr.new_cmd('CopyLinkW', 'lua Link:copyRWrokspace()')
    wr.new_cmd('CopyLinkB', 'lua Link:copyRBuf()')

end

return M
