local util = require("util")
local config = require("config")

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- {'3rd/image.nvim', opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false,
	---@module 'neo-tree'
	---@type neotree.Config?
	opts = require("plugins.opts.neo-tree"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("neo-tree"), util.keymap_to_lazykey),
}
