local config = require("config")

return {
	server = {
		on_attach = function(client, bufnr)
      require("config.lsp.helpers.set_common_keymaps").setup(client, bufnr)
      -- override some of the commom LSP keymaps with rust-specific ones (eg. hover, code-action)
			config.mapping.set_namespaced_keymaps("rustaceanvim", { buffer = bufnr })
		end,
	},
}
