local util = require("util")
local config = require("config")

local methods = vim.lsp.protocol.Methods

local M = {}

---@param keymap config.mapping.KeyMap
---@param extra_opts? config.mapping.ExtraKeymapsetOpts
local set_keymap = function(keymap, extra_opts)
	---@type vim.keymap.set.Opts
	local opts = {}
	opts.desc = keymap.opts.desc
	opts.noremap = keymap.opts.noremap
	if extra_opts ~= nil then
		if extra_opts.buffer ~= nil then
			opts.buffer = extra_opts.buffer
		end
	end

	vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, opts)
end

---@param client vim.lsp.Client
---@param bufnr number
M.setup = function(client, bufnr)
	local keymaps = util.map_array_to_table(
		config.mapping.get_namespaced_keymaps("nvim-lspconfig-common"),
		function(keymap)
			return keymap.lhs
		end
	)
	---@type config.mapping.ExtraKeymapsetOpts
	local extra_opts = { buffer = bufnr }

	-- check for signature help support
	if client:supports_method(methods.textDocument_signatureHelp) then
		set_keymap(keymaps["<c-k>"], extra_opts)
	end

	-- check for hover support
	if client:supports_method(methods.textDocument_hover) then
		set_keymap(keymaps["K"], extra_opts)
	end

	-- check for definition support
	if client:supports_method(methods.textDocument_definition) then
		set_keymap(keymaps["gd"], extra_opts)
	end

	-- check for declaration support
	if client:supports_method(methods.textDocument_declaration) then
		set_keymap(keymaps["gD"], extra_opts)
	end

	-- check for implementation support
	if client:supports_method(methods.textDocument_implementation) then
		set_keymap(keymaps["gi"], extra_opts)
	end

	-- check for references support
	if client:supports_method(methods.textDocument_references) then
		set_keymap(keymaps["gr"], extra_opts)
	end

	-- check for type definition support
	if client:supports_method(methods.textDocument_typeDefinition) then
		set_keymap(keymaps["gy"], extra_opts)
	end

	-- check for code action support
	if client:supports_method(methods.textDocument_codeAction) then
		set_keymap(keymaps["<leader>ca"], extra_opts)
	end

	-- check for rename support
	if client:supports_method(methods.textDocument_rename) then
		set_keymap(keymaps["<leader>rn"], extra_opts)
	end
end

return M
