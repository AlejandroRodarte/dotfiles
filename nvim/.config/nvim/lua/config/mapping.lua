---@alias config.mapping.KeyMap.Rhs string | function

---@class config.mapping.KeyMap
---@field mode string[]
---@field lhs string
---@field rhs config.mapping.KeyMap.Rhs
---@field opts { desc: string, noremap: boolean }
---@field ns string

local M = {}

---
--- Generate a table of type `config.mapping.KeyMap`.
---
---@param mode string | string[]
---@param lhs string
---@param rhs string | function
---@param opts string | { desc: string, noremap: boolean }
---@param ns? string
---@return config.mapping.KeyMap
local function mk_keymap(mode, lhs, rhs, opts, ns)
	if type(opts) == "string" then
		opts = { desc = opts, noremap = true }
	end
	if type(mode) == "table" then
		mode = table.concat(mode)
	end

	local chars = {}
	for i = 1, #mode do
		table.insert(chars, mode:sub(i, i))
	end

	return {
		mode = chars,
		lhs = lhs,
		rhs = rhs,
		opts = opts,
		ns = ns,
	}
end

M.keys = {
	mk_keymap("n", "<esc>", ":noh<cr><esc>", "Clear search highlight"),

	-- window navigation keymaps
	mk_keymap("n", "<c-k>", "<cmd>wincmd k<cr>", "Move to upwards window"),
	mk_keymap("n", "<c-j>", "<cmd>wincmd j<cr>", "Move to downwards window"),
	mk_keymap("n", "<c-h>", "<cmd>wincmd h<cr>", "Move to left window"),
	mk_keymap("n", "<c-l>", "<cmd>wincmd l<cr>", "Move to right window"),

	mk_keymap("n", "<c-n>", "<cmd>Neotree filesystem reveal left<cr>", "Open file explorer (to the left)", "neo-tree"),
	mk_keymap("n", "<leader>gf", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, "Format code (conform.nvim)", "conform"),

	-- Special case: nvim-cmp keymap functions are called with a `fallback` function
	-- provided by the library itself; this is needed for the plugin to work properly.
	-- The code inside these keymap functions is derived from
	-- [this source code file](https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua)
	mk_keymap("i", "<c-b>", function(fallback)
		if not require("cmp").scroll_docs(-4) then
			fallback()
		end
	end, "Scroll documentation backwards (nvim-cmp)", "nvim-cmp"),
	mk_keymap("i", "<c-f>", function(fallback)
		if not require("cmp").scroll_docs(4) then
			fallback()
		end
	end, "Scroll documentation upwards (nvim-cmp)", "nvim-cmp"),
	mk_keymap("i", "<c-space>", function(fallback)
		if not require("cmp").complete() then
			fallback()
		end
	end, "Show autocomplete window", "nvim-cmp"),
	mk_keymap("i", "<c-e>", function(fallback)
		if not require("cmp").abort() then
			fallback()
		end
	end, "Close autocomplete window", "nvim-cmp"),
	mk_keymap("i", "<cr>", function(fallback)
		if not require("cmp").confirm({ select = true }) then
			fallback()
		end
	end, "Select autocomplete option", "nvim-cmp"),

	mk_keymap("n", "<leader>dt", function()
		require("dap").toggle_breakpoint()
	end, { desc = "Toggle breakpoint (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dc", function()
		require("dap").continue()
	end, { desc = "Continue the program's execution (nvim-dap)" }, "nvim-dap"),
}

---
--- Get all `config.mapping.KeyMap` instances related to a specific namespace `ns`.
---
---@param ns string
---@return config.mapping.KeyMap[]
function M.get_namespaced_keymaps(ns)
	local r = {}

	for _, m in ipairs(M.keys) do
		if m.ns == ns then
			table.insert(r, m)
		end
	end

	return r
end

---
--- Set all keymaps related to a specific namespace `ns`.
---
---@param ns string
function M.set_namespaced_keymaps(ns)
	local keymaps = M.get_namespaced_keymaps(ns)
	for _, v in ipairs(keymaps) do
		vim.keymap.set(v.mode, v.lhs, v.rhs, v.opts)
	end
end

return M
