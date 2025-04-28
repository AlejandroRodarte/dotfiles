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

	mk_keymap("n", "gK", function()
		vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
	end, { desc = "Toggle virtual lines (global; applies to all diagnostic namespaces)" }, "nvim-lint"),
	mk_keymap("n", "<leader>li", function()
		require("lint").try_lint()
	end, { desc = "Try linting (nvim-lint)" }, "nvim-lint"),

	mk_keymap(
		"n",
		"K",
		vim.lsp.buf.hover,
		"Display hover information (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),
	mk_keymap(
		"n",
		"gd",
		vim.lsp.buf.definition,
		"Go to definition of symbol (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),
	mk_keymap(
		"n",
		"<leader>ca",
		vim.lsp.buf.code_action,
		"Display code actions (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),

	mk_keymap("n", "<leader>ca", function()
		vim.cmd.RustLsp("codeAction")
	end, "Display code actions (RustLsp, from rustaceanvim)", "rustaceanvim"),
	mk_keymap("n", "K", function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end, "Display hover information (RustLsp, from rustaceanvim)", "rustaceanvim"),
	mk_keymap("n", "gd", vim.lsp.buf.definition, "Go to definition (using vim.lsp.buf API)", "rustaceanvim"),

	mk_keymap("n", "<leader>ff", function()
		require("telescope.builtin").find_files()
	end, "Find files (telescope)", "telescope"),
	mk_keymap("n", "<leader>fg", function()
		require("telescope.builtin").live_grep()
	end, "Live grep (telescope)", "telescope"),
	mk_keymap("n", "<leader>fb", function()
		require("telescope.builtin").buffers()
	end, "Buffers files (telescope)", "telescope"),
	mk_keymap("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end, "Help tags (telescope)", "telescope"),
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
