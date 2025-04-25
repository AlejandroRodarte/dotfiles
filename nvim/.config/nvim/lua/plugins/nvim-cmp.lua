return {
	"hrsh7th/nvim-cmp",
	config = function(lazyplugin, opts)
		local cmp = require("cmp")
		cmp.setup(require("plugins.opts.nvim-cmp").build_opts(cmp))
	end,
}
