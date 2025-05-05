return {
	"lewis6991/gitsigns.nvim",
	opts = require("plugins.opts.gitsigns"),
	config = function(lazyplugin, opts)
		require("gitsigns").setup(opts)
	end,
}
