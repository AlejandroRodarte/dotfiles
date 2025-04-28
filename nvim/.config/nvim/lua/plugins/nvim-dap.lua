local util = require("util")
local config = require("config")

return {
	"mfussenegger/nvim-dap",
	keys = util.map_array(config.mapping.get_namespaced_keymaps("nvim-dap"), util.keymap_to_lazykey),
	config = function(lazyplugin, opts)
		require("plugins.config.nvim-dap")
	end,
}
