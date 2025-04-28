local util = require("util")
local config = require("config")

return {
	"vim-test/vim-test",
	opts = require("plugins.opts.vim-test"),
	keys = util.map_array(config.mapping.get_namespaced_keymaps("vim-test"), util.keymap_to_lazykey),
}
