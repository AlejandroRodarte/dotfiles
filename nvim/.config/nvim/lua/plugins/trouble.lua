local util = require("util")
local config = require("config")

return {
	"folke/trouble.nvim",
	opts = require("plugins.opts.trouble"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("trouble"), util.keymap_to_lazykey),
}
