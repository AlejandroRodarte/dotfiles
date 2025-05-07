return {
	server = {
		on_attach = function(client, bufnr)
			require("plugins.config.nvim-lspconfig.helpers.set_common_keymaps").setup(client, bufnr)
		end,
	},
}
