-- diagnostic api settings
-- virtual lines for diagnostics enabled by default
vim.diagnostic.config({ virtual_lines = true })

-- keymaps
-- `<leader>` exists for custom mappings
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "vim.lsp.buf.format" })
-- `g` is seen as a "system <leader> key", meaning we can use it for more custom mappings
vim.keymap.set("n", "gK", function()
	vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end, { desc = "Toggle virtual lines (global; applies to all diagnostic namespaces)" })
-- warning: hard-coded string might break in the future
local namespace = "NULL_LS_SOURCE_3"
vim.keymap.set("n", "<leader>gdl", function()
	local namespace_id = vim.api.nvim_get_namespaces()[namespace]
	vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config(nil, namespace_id).virtual_lines }, namespace_id)
end, { desc = "Toggle virtual lines (per-namespace; targets linter diagnostic namespace)" })
