require("telescope").setup({
	defaults = {
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				height = 0.9,
				preview_cutoff = 40,
				prompt_position = "bottom",
				width = 0.9,
			},
		},
	},
	pickers = {
		find_files = {
			mappings = {
				n = {
					["R"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						-- Depending on what you want put `cd`, `lcd`, `tcd`
						vim.cmd(string.format("silent !open -R \"%s\"", selection.path))
					end,
					["X"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(string.format("silent !open \"%s\"", selection.path))
					end,
				},
			},
		},
		buffers = {
			mappings = {
				n = {
					["r"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
                        local info = vim.fn.getbufinfo(selection.bufnr)[1]
						vim.cmd(string.format("!open -R \"%s\"", info.name))
					end,
					["x"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
                        local info = vim.fn.getbufinfo(selection.bufnr)[1]
						vim.cmd(string.format("!open \"%s\"", info.name))
					end,
					["d"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(string.format("bd %d", selection.bufnr))
					end,
					["s"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(string.format("sb %d", selection.bufnr))
					end,
					["t"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(string.format("tab sb %d", selection.bufnr))
					end,
				},
			},
		},
	},
	extensions = {
		-- ...
	},
})
