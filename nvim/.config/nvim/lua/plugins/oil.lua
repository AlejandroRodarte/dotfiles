local config = require("config")
local util = require("util")

return {
	"stevearc/oil.nvim",
	opts = require("plugins.opts.oil"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("oil"), util.keymap_to_lazykey),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
}
