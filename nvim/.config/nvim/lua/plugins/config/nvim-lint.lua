local lint = require("lint")

-- diagnostic api settings
-- virtual lines for diagnostics enabled by default
vim.diagnostic.config({ virtual_lines = true })

-- autocmds
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})
