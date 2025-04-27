local util = require("util")
local config = require("config")

return {
	"stevearc/conform.nvim",
	opts = require("plugins.opts.conform"),
	keys = util.map_array(config.mapping.get_namespaced("conform"), util.keymap_to_lazykey),
	config = function(lazyplugin, opts)
		require("conform").setup(opts)
		require("plugins.config.conform")
	end,
}
