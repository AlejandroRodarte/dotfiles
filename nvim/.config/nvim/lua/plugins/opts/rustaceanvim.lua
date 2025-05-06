local config = require("config")

return {
	server = {
		on_attach = function(client, bufnr)
			config.mapping.set_namespaced_keymaps("nvim-lspconfig-common", { buffer = bufnr })
      -- override some of the commom LSP keymaps with rust-specific ones (eg. hover, code-action)
			config.mapping.set_namespaced_keymaps("rustaceanvim", { buffer = bufnr })
		end,
	},
}
