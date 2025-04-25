return {
	"folke/lazydev.nvim",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	ft = "lua", -- only load on lua files
	opts = require("plugins.opts.lazydev"),
}
