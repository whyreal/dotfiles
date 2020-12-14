local M = {}

M.setup = function ()
	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.wo.foldmethod = 'expr'

	vim.g.tagbar_sort = 0

	-- Toggle Bold
	wr.maplua('n', '<LocalLeader>b', 'wr.TextRange:new("**", "**", false):toggle_word_wrap()', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>b', 'wr.TextRange:new("**", "**", true):toggle_word_wrap()', {buffer = true})

	-- Toggle Italic
	wr.maplua('n', '<LocalLeader>i', 'wr.TextRange:new("*", "*", false):toggle_word_wrap()', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>i', 'wr.TextRange:new("*", "*", true):toggle_word_wrap()', {buffer = true})

	-- preview
	wr.mapcmd('n', '<LocalLeader>p', 'ComposerOpen', {buffer = true})

	-- Bold object
	wr.map_norange_lua('v', 'ab', 'wr.TextRange:new("**", "**", false):select_all()', {buffer = true})
	wr.map_norange_lua('v', 'ib', 'wr.TextRange:new("**", "**", false):select_inner()', {buffer = true})
	wr.map_norange_lua('o', 'ab', 'wr.TextRange:new("**", "**", false):select_all()', {buffer = true})
	wr.map_norange_lua('o', 'ib', 'wr.TextRange:new("**", "**", false):select_inner()', {buffer = true})

	-- Italic object
	wr.map_norange_lua('v', 'ai', 'wr.TextRange:new("*", "*", false):select_all()', {buffer = true})
	wr.map_norange_lua('v', 'ii', 'wr.TextRange:new("*", "*", false):select_inner()', {buffer = true})
	wr.map_norange_lua('o', 'ai', 'wr.TextRange:new("*", "*", false):select_all()', {buffer = true})
	wr.map_norange_lua('o', 'ii', 'wr.TextRange:new("*", "*", false):select_inner()', {buffer = true})

	-- Link object
	wr.map_norange_lua('v', 'al', 'wr.TextRange:new("[", ")", false):select_all()', {buffer = true})
	wr.map_norange_lua('v', 'il', 'wr.TextRange:new("[", ")", false):select_inner()', {buffer = true})
	wr.map_norange_lua('o', 'al', 'wr.TextRange:new("[", ")", false):select_all()', {buffer = true})
	wr.map_norange_lua('o', 'il', 'wr.TextRange:new("[", ")", false):select_inner()', {buffer = true})

	-- create list
	wr.map_norange_lua('v', '<LocalLeader>nl', 'wr.TextRange:new("", "", true):make_list()', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>no', 'wr.TextRange:new("", "", true):make_ordered_list()', {buffer = true})

	-- delete list
	wr.map_norange_lua('v', '<LocalLeader>dl', 'wr.TextRange:new("", "", true):remove_list()', {buffer = true})
	wr.map_norange_lua('v', '<LocalLeader>do', 'wr.TextRange:new("", "", true):remove_ordered_list()', {buffer = true})
end

return M
