return {
	"stevearc/conform.nvim",
	opts = require("plugins.opts.conform"),
	config = function(lazyplugin, opts)
		require("conform").setup(opts)
		require("plugins.config.conform")
	end,
}
