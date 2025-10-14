local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("java_language_server", {
	capabilities = capabilities,
})
