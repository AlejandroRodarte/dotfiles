return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = require("plugins.opts.catppuccin"),
	config = function(lazyplugin, opts)
		require("catppuccin").setup(opts)
		require("plugins.config.catppuccin")
	end,
}
