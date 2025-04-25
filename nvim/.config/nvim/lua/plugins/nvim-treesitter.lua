return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = require("plugins.opts.nvim-treesitter"),
	config = function(lazyplugin, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
