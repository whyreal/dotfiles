local utils = require("wr.utils")
local M = {}

M.setup = function ()

	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.wo.foldmethod = 'expr'

	vim.g.tagbar_sort = 0

	vim.g.vim_markdown_no_default_key_mappings = 1

	-- Bold object
	utils.map_norange_lua('v', 'ab', 'WrappedRange:newFromSep("**", "**"):select_all()',   {buffer = true})
	utils.map_norange_lua('v', 'ib', 'WrappedRange:newFromSep("**", "**"):select_inner()', {buffer = true})
	utils.map_norange_lua('o', 'ab', 'WrappedRange:newFromSep("**", "**"):select_all()',   {buffer = true})
	utils.map_norange_lua('o', 'ib', 'WrappedRange:newFromSep("**", "**"):select_inner()', {buffer = true})

	-- Italic object
	utils.map_norange_lua('v', 'ai', 'WrappedRange:newFromSep("*",  "*"):select_all()',    {buffer = true})
	utils.map_norange_lua('v', 'ii', 'WrappedRange:newFromSep("*",  "*"):select_inner()',  {buffer = true})
	utils.map_norange_lua('o', 'ai', 'WrappedRange:newFromSep("*",  "*"):select_all()',    {buffer = true})
	utils.map_norange_lua('o', 'ii', 'WrappedRange:newFromSep("*",  "*"):select_inner()',  {buffer = true})

	-- Toggle Bold
	utils.maplua('n',          '<LocalLeader>b',  'WrappedRange.toggle_wrap("**", "**", false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>b',  'WrappedRange.toggle_wrap("**", "**", true)',  {buffer = true})

	-- Toggle Italic
	utils.maplua('n',          '<LocalLeader>i',  'WrappedRange.toggle_wrap("*", "*",  false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>i',  'WrappedRange.toggle_wrap("*", "*",  true)',  {buffer = true})

	-- Toggle Inline code
	utils.maplua('n',          '<LocalLeader>c',  'WrappedRange.toggle_wrap("`", "`",  false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>c',  'WrappedRange.toggle_wrap("`", "`",  true)',  {buffer = true})

	-- create list
	utils.map_norange_lua('v', '<LocalLeader>nl', 'Range:newFromVisual():make_list()',         {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>no', 'Range:newFromVisual():make_ordered_list()', {buffer = true})

	-- delete list
	utils.map_norange_lua('v', '<LocalLeader>dl', 'Range:newFromVisual():remove_list()', {buffer = true})

	-- preview
	utils.mapcmd('n', '<LocalLeader>p', 'ComposerOpen', {buffer = true})

    -- Follow Link
    utils.maplua('n', 'gx', 'Link:new():open()', {buffer = true})
    utils.new_cmd('CopyLinkW', 'lua Link:copyRWrokspace()')
    utils.new_cmd('CopyLinkB', 'lua Link:copyRBuf()')

end

return M
