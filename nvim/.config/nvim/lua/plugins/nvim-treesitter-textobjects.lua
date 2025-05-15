return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = require("plugins.opts.nvim-treesitter-textobjects"),
	config = function(lazyplugin, opts)
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			textobjects = opts,
		})
	end,
}
