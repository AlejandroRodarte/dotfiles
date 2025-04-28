local util = require("util")
local config = require("config")

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = util.map_array(config.mapping.get_namespaced_keymaps("telescope"), util.keymap_to_lazykey),
	opts = require("plugins.opts.telescope"),
	config = function(lazyplugin, opts)
		require("telescope").setup(opts)
		require("plugins.config.telescope")
	end,
}
