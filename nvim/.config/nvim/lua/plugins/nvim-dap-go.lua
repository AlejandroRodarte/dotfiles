return {
	"leoluz/nvim-dap-go",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	opts = require("plugins.opts.nvim-dap-go"),
	config = function(lazyplugin, opts)
		require("dap-go").setup(opts)
	end,
}
