local util = require("util")
local config = require("config")

return {
	"vim-test/vim-test",
	dependencies = {
		"preservim/vimux",
	},
	keys = util.map_array(config.mapping.get_namespaced_keymaps("vim-test"), util.keymap_to_lazykey),
	config = function(lazyplugin, opts)
		require("plugins.config.vim-test")
	end,
}
