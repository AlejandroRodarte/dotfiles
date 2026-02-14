local M = {}

function M.setup()
	vim.lsp.enable("cssls")
	vim.lsp.enable("emmet_language_server")
	vim.lsp.enable("gdscript")
	vim.lsp.enable("gopls")
	vim.lsp.enable("java_language_server")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("svelte")
	vim.lsp.enable("ts_ls")
	vim.lsp.enable("tailwindcss")

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			else
				require("config.lsp.helpers.set_common_keymaps").setup(client, bufnr)
			end
		end,
	})
end

return M
