return {
	server = {
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, { desc = 'vim.cmd.RustLsp("codeAction")' })
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { desc = 'vim.cmd.RustLsp({ "hover", "actions" })' })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
		end,
	},
}
