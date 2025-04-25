return {
	"m4xshen/autoclose.nvim",
	opts = require("plugins.opts.autoclose"),
	config = function(lazyplugin, opts)
		require("autoclose").setup(opts)
	end,
}
