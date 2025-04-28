local util = require("util")
local config = require("config")

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = require("plugins.opts.which-key"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("which-key"), util.keymap_to_lazykey),
}
