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
