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
	keys = util.map(config.mapping.get_namespaced("neo-tree"), util.key_to_lazyspec),
}
