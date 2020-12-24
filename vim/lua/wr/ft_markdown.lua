local utils = require("wr.utils")
local M = {}

M.setup = function ()

	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.wo.foldmethod = 'expr'

	vim.g.tagbar_sort = 0

	vim.g.vim_markdown_no_default_key_mappings = 1

	-- Bold object
	utils.map_norange_lua('v', 'ab', 'require[[wr.WrappedRange]]:newFromSep("**", "**"):select_all()',   {buffer = true})
	utils.map_norange_lua('v', 'ib', 'require[[wr.WrappedRange]]:newFromSep("**", "**"):select_inner()', {buffer = true})
	utils.map_norange_lua('o', 'ab', 'require[[wr.WrappedRange]]:newFromSep("**", "**"):select_all()',   {buffer = true})
	utils.map_norange_lua('o', 'ib', 'require[[wr.WrappedRange]]:newFromSep("**", "**"):select_inner()', {buffer = true})

	-- Italic object
	utils.map_norange_lua('v', 'ai', 'require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_all()',    {buffer = true})
	utils.map_norange_lua('v', 'ii', 'require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_inner()',  {buffer = true})
	utils.map_norange_lua('o', 'ai', 'require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_all()',    {buffer = true})
	utils.map_norange_lua('o', 'ii', 'require[[wr.WrappedRange]]:newFromSep("*",  "*"):select_inner()',  {buffer = true})

	-- Toggle ""
	utils.maplua('n',          '<LocalLeader>"',  'require[[wr.WrappedRange]].toggle_wrap([["]], [["]], false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>"',  'require[[wr.WrappedRange]].toggle_wrap([["]], [["]], true)',  {buffer = true})

	-- Toggle Bold
	utils.maplua('n',          '<LocalLeader>b',  'require[[wr.WrappedRange]].toggle_wrap("**", "**", false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>b',  'require[[wr.WrappedRange]].toggle_wrap("**", "**", true)',  {buffer = true})

	-- Toggle Italic
	utils.maplua('n',          '<LocalLeader>i',  'require[[wr.WrappedRange]].toggle_wrap("*", "*",  false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>i',  'require[[wr.WrappedRange]].toggle_wrap("*", "*",  true)',  {buffer = true})

	-- Toggle Inline code
	utils.maplua('n',          '<LocalLeader>c',  'require[[wr.WrappedRange]].toggle_wrap("`", "`",  false)', {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>c',  'require[[wr.WrappedRange]].toggle_wrap("`", "`",  true)',  {buffer = true})

	-- create list
	utils.map_norange_lua('v', '<LocalLeader>nl', 'require[[wr.Range]]:newFromVisual():make_list()',         {buffer = true})
	utils.map_norange_lua('v', '<LocalLeader>no', 'require[[wr.Range]]:newFromVisual():make_ordered_list()', {buffer = true})

	-- delete list
	utils.map_norange_lua('v', '<LocalLeader>dl', 'require[[wr.Range]]:newFromVisual():remove_list()', {buffer = true})

	-- preview
	utils.mapcmd('n', '<LocalLeader>p', 'ComposerOpen', {buffer = true})

    -- open Link
    utils.maplua('n', 'gl', 'require[[wr.Link]]:new():open()', {buffer = true})
	-- resolv file in Finder
    utils.maplua('n', 'gr', 'require[[wr.Link]]:new():resolv()', {buffer = true})

    utils.new_cmd('-buffer CopyAnchorLinkW', 'lua require[[wr.Link]]:copyRWrokspace()')
    utils.new_cmd('-buffer CopyNoAnchorLinkW', 'lua require[[wr.Link]]:copyRWrokspace(true)')
    utils.new_cmd('-buffer CopyAnchorLinkB', 'lua require[[wr.Link]]:copyRBuf()')
end

return M
