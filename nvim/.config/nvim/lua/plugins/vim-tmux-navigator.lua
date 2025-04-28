local util = require("util")
local config = require("config")

return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	keys = util.map_array(config.mapping.get_namespaced_keymaps("vim-tmux-navigator"), util.keymap_to_lazykey),
}
