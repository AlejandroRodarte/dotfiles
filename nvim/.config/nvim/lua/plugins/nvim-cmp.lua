return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"luckasRanarison/tailwind-tools.nvim",
		"onsails/lspkind.nvim",
	},
	config = function(lazyplugin, opts)
		local cmp = require("cmp")
		cmp.setup(require("plugins.opts.nvim-cmp").build_opts(cmp))
	end,
}
