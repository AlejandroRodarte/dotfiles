local util = require("util")
local config = require("config")

return {
	"mfussenegger/nvim-lint",
	keys = util.map_array(config.mapping.get_namespaced_keymaps("nvim-lint"), util.keymap_to_lazykey),
	opts = require("plugins.opts.nvim-lint"),
	config = function(lazyplugin, opts)
		require("lint").linters_by_ft = opts.linters_by_ft
		require("plugins.config.nvim-lint")
	end,
}
