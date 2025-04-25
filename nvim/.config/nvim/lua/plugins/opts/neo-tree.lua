return {
	window = {
		mappings = {
			["<tab>"] = {
				function(state)
					state.commands["open"](state)
					vim.cmd("Neotree reveal")
				end,
				desc = "Open file (without focus)",
			},
		},
	},
}
