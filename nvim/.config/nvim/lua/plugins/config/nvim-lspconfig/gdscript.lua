local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("gdscript", {
	on_attach = function(client, bufnr)
    require("plugins.config.nvim-lspconfig.helpers.set_common_keymaps").setup(client, bufnr)
	end,
	capabilities = capabilities,
})
