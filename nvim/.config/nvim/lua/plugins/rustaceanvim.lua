return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	lazy = false,
	opts = require("plugins.opts.rustaceanvim"),
	config = function(lazyplugin, opts)
		vim.g.rustaceanvim = opts
	end,
}
