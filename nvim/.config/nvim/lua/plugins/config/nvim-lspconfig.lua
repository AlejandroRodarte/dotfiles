local on_attach = function(client, bufnr)
	-- `K` is fine as {lhs} of this keymap since there are no builtin functions attached to it
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "vim.lsp.buf.hover" })
	-- `g` commonly referred to as a "namespace"; it's like a "system <leader> key" you can use for custom mappings
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
	-- the whole purpose of `<leader>` is to build custom mappings
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "vim.lsp.buf.code_action" })

	local namespace = "vim.lsp." .. client.name .. "." .. client.id
	vim.keymap.set("n", "<leader>gdk", function()
		local namespace_id = vim.api.nvim_get_namespaces()[namespace]
		vim.diagnostic.config(
			{ virtual_lines = not vim.diagnostic.config(nil, namespace_id).virtual_lines },
			namespace_id
		)
	end, { desc = "Toggle virtual lines (per-namespace; targets LSP diagnostic namespace)" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("gopls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("java_language_server", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end
	end,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})

-- vim.lsp.config("rust_analyzer", {
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	settings = {
-- 		["rust-analyzer"] = {
-- 			checkOnSave = {
-- 				command = "clippy",
-- 			},
-- 		},
-- 	},
-- })

vim.lsp.config("ts_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.enable("java_language_server")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
-- vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
