return {
	"folke/trouble.nvim",
	opts = require("plugins.opts.trouble"),
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (trouble.nvim)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (trouble.nvim)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (trouble.nvim)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / References / ... (trouble.nvim)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (trouble.nvim)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (trouble.nvim)",
		},
	},
}
