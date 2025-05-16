local util = require("util")
local config = require("config")

return {
	ensure_installed = {
		"bash",
		"c",
		"css",
		"dockerfile",
		"gitignore",
		"go",
		"graphql",
		"html",
		"java",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"rust",
		"scss",
		"tsx",
		"typescript",
		"yaml",
	},
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = util.merge_tables(
			{ scope_incremental = false },
			util.map_array_to_table(
				config.mapping.get_namespaced_keymaps("nvim-treesitter-incremental-selection"),
				function(keymap)
					return keymap.plugin_specs.nvim_treesitter.incremental_selection.action
				end,
				util.keymap_to_lhs
			)
		),
	},
}
