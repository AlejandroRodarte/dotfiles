local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("cssls", {
	capabilities = capabilities,
})
