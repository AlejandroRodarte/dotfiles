local capabilities = require("cmp_nvim_lsp").default_capabilities()
local config = require("config")

vim.lsp.config("java_language_server", {
	on_attach = function(client, bufnr)
		config.mapping.set_namespaced_keymaps("nvim-lspconfig-common", { buffer = bufnr })
	end,
	capabilities = capabilities,
})
