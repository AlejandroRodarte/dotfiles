local util = require("util")
local config = require("config")

return {
	"stevearc/conform.nvim",
	opts = require("plugins.opts.conform"),
	keys = util.map(config.mapping.get_namespaced("conform"), util.key_to_lazyspec),
	config = function(lazyplugin, opts)
		require("conform").setup(opts)
		require("plugins.config.conform")
	end,
}
