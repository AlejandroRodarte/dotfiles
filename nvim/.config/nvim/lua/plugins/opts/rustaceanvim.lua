local config = require("config")

return {
	server = {
		on_attach = function(client, bufnr)
			config.mapping.set_namespaced_keymaps("rustaceanvim")
		end,
	},
}
