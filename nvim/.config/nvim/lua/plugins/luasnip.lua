return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"rafamadriz/friendly-snippets",
	},
	version = "v2.*",
	build = "make install_jsregexp",
	config = function(lazyplugin, opts)
		require("plugins.config.luasnip")
	end,
}
