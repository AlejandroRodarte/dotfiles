return {
	"mfussenegger/nvim-lint",
	opts = require("plugins.opts.nvim-lint"),
	config = function(lazyplugin, opts)
		require("lint").linters_by_ft = opts.linters_by_ft
		require("plugins.config.nvim-lint")
	end,
}
