return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- {'3rd/image.nvim', opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false,
	---@module 'neo-tree'
	---@type neotree.Config?
	opts = require("plugins.opts.neo-tree"),
	config = function(lazyplugin, opts)
		require("neo-tree").setup(opts)
		require("plugins.config.neo-tree")
	end,
}
