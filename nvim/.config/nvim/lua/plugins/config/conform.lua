-- autocmds
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf, lsp_format = "fallback" })
	end,
})

-- vim options
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
