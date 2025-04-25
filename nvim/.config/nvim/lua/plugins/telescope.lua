return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = require("plugins.opts.telescope"),
	config = function(lazyplugin, opts)
		require("telescope").setup(opts)
		require("plugins.config.telescope")
	end,
}
