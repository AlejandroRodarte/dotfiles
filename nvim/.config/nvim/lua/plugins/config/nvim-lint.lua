local lint = require("lint")

-- diagnostic api settings
-- virtual lines for diagnostics enabled by default
vim.diagnostic.config({ virtual_lines = true })

-- keymaps
vim.keymap.set("n", "gK", function()
	vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end, { desc = "Toggle virtual lines (global; applies to all diagnostic namespaces)" })
vim.keymap.set("n", "<leader>li", lint.try_lint, { desc = "lint.try_lint" })

-- autocmds
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})
