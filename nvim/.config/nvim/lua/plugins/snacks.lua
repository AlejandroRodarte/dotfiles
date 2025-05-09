local config = require("config")
local util = require("util")

return {
	"folke/snacks.nvim",
	opts = require("plugins.opts.snacks"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("snacks"), util.keymap_to_lazykey),
}
