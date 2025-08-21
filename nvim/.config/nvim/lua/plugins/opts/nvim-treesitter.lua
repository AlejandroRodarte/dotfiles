local util = require("util")
local config = require("config")

return {
	ensure_installed = {
		"angular",
		"astro",
		"bash",
		"c",
		"css",
		"csv",
		"dockerfile",
		"editorconfig",
		"gdscript",
		"godot_resource",
		"gdshader",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"graphql",
		"html",
		"java",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"matlab",
		"nginx",
		"php",
		"prisma",
		"properties",
		"python",
		"rust",
		"scss",
		"sql",
		"svelte",
		"tsx",
		"typescript",
		"vue",
		"yaml",
	},
	highlight = { enable = true },
	indent = {
    enable = true,
    disable = { "gdscript" },
  },
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
