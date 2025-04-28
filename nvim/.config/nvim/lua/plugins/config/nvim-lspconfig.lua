local config = require("config")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("gopls", {
	on_attach = function(client, bufnr)
		config.mapping.set_namespaced_keymaps("nvim-lspconfig-common")
	end,
	capabilities = capabilities,
})

vim.lsp.config("java_language_server", {
	on_attach = function(client, bufnr)
		config.mapping.set_namespaced_keymaps("nvim-lspconfig-common")
	end,
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	on_attach = function(client, bufnr)
		config.mapping.set_namespaced_keymaps("nvim-lspconfig-common")
	end,
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

vim.lsp.config("ts_ls", {
	on_attach = function(client, bufnr)
		config.mapping.set_namespaced_keymaps("nvim-lspconfig-common")
	end,
	capabilities = capabilities,
})

vim.lsp.enable("java_language_server")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("gopls")
