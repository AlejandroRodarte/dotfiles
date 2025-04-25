return {
	"nvimtools/none-ls.nvim",
	config = function(lazyplugin, opts)
		local null_ls = require("null-ls")
		null_ls.setup(require("plugins.opts.none-ls").build_opts(null_ls))
		require("plugins.config.none-ls")
	end,
	enabled = false,
}
