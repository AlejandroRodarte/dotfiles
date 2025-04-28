local capabilities = require("cmp_nvim_lsp").default_capabilities()
local config = require("config")

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
