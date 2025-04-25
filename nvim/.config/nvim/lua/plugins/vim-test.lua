return {
	"vim-test/vim-test",
	opts = require("plugins.opts.vim-test"),
	config = function(lazyplugin, opts)
		require("plugins.config.vim-test")
	end,
}
