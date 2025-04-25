return {
	library = {
		"nvim-dap-ui",
		-- load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
}
