---@class config.mapping.ExtraKeymapsetOpts
---@field buffer? number

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

-- before keymaps are defined, remove default LSP keymaps
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")

-- ===> start of notes about keymaps ===>
-- Special case: nvim-cmp keymap functions are called with a `fallback` function
-- provided by the library itself; this is needed for the plugin to work properly.
-- The code inside these keymap functions is derived from
-- [this source code file](https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua)
-- <=== end of notes about keymaps <===

M.keys = {
	-- ===> start of single-key lhs (e.g. <esc>, K, <cr>) ===>
	mk_keymap("n", "<esc>", ":noh<cr><esc>", "Clear search highlight"),
	mk_keymap(
		"n",
		"K",
		vim.lsp.buf.hover,
		"Display hover information (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),
	mk_keymap("n", "K", function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end, "Display hover information (RustLsp, from rustaceanvim)", "rustaceanvim"),

	mk_keymap("i", "<cr>", function(fallback)
		if not require("cmp").confirm({ select = true }) then
			fallback()
		end
	end, "Select autocomplete option", "nvim-cmp"),
	-- <=== end of single-key lhs (e.g. <esc>, K, <cr>) <===

	-- ===> start of ctrl-key lhs (e.g. <c-n>, <c-j>) ===>
	mk_keymap("n", "<c-up>", "<cmd>resize +2<cr>", { desc = "Increase window height" }),
	mk_keymap("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" }),
	mk_keymap("n", "<c-left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" }),
	mk_keymap("n", "<c-right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" }),

	mk_keymap(
		"n",
		"<c-h>",
		"<cmd><c-u>TmuxNavigateLeft<cr>",
		"Navigate to left pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	mk_keymap(
		"n",
		"<c-j>",
		"<cmd><c-u>TmuxNavigateDown<cr>",
		"Navigate to downwards pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	mk_keymap(
		"n",
		"<c-k>",
		"<cmd><c-u>TmuxNavigateUp<cr>",
		"Navigate to upwards pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	mk_keymap(
		"n",
		"<c-l>",
		"<cmd><c-u>TmuxNavigateRight<cr>",
		"Navigate to right pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	mk_keymap("n", "<c-n>", "<cmd>Neotree filesystem reveal left<cr>", "Open file explorer (to the left)", "neo-tree"),
	mk_keymap(
		"n",
		"<c-\\>",
		"<cmd><c-u>TmuxNavigatePrevious<cr>",
		"Navigate to previous pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),

	mk_keymap("i", "<c-b>", function(fallback)
		if not require("cmp").scroll_docs(-4) then
			fallback()
		end
	end, "Scroll documentation backwards (nvim-cmp)", "nvim-cmp"),
	mk_keymap("i", "<c-e>", function(fallback)
		if not require("cmp").abort() then
			fallback()
		end
	end, "Close autocomplete window", "nvim-cmp"),
	mk_keymap("i", "<c-f>", function(fallback)
		if not require("cmp").scroll_docs(4) then
			fallback()
		end
	end, "Scroll documentation upwards (nvim-cmp)", "nvim-cmp"),
	mk_keymap("i", "<c-k>", function()
		local cmp = require("cmp")
		if cmp.visible() then
			cmp.abort()
		end
		vim.lsp.buf.signature_help()
	end, "Signature help (LSP)", "nvim-lspconfig-common"),
	mk_keymap("i", "<c-space>", function(fallback)
		if not require("cmp").complete() then
			fallback()
		end
	end, "Show autocomplete window", "nvim-cmp"),
	-- <=== end of ctrl-key lhs (e.g. <c-n>, <c-j>) <===

	-- ===> start of g-key lhs (alphabetically ordered) (e.g. gd, gK) ===>
	mk_keymap(
		"n",
		"gd",
		vim.lsp.buf.definition,
		"Go to definition of symbol (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),
	mk_keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration (LSP)", "nvim-lspconfig-common"),
	mk_keymap("n", "gi", vim.lsp.buf.implementation, "Go to implementation (LSP)", "nvim-lspconfig-common"),
	mk_keymap("n", "gK", function()
		vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
	end, { desc = "Toggle virtual lines (global; applies to all diagnostic namespaces)" }),
	mk_keymap(
		"n",
		"gr",
		vim.lsp.buf.references,
		"List all references in the quickfix window (LSP)",
		"nvim-lspconfig-common"
	),
	mk_keymap("n", "gt", vim.lsp.buf.type_definition, "Go to type definition (LSP)", "nvim-lspconfig-common"),
	-- <=== end of g-key lhs (alphabetically ordered) (e.g. gd, gK) <===

	-- ===> start of ]-key lhs ===>
	mk_keymap("n", "]c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "]c", bang = true })
		else
			require("gitsigns").nav_hunk("next")
		end
	end, "Navigate to next hunk (gitsigns)", "gitsigns"),
	mk_keymap("n", "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Jump to next diagnostic"),
	mk_keymap("n", "]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, "Jump to next error diagnostic"),
	-- <=== end of ]-key lhs ===>

	-- ===> start of [-key lhs ===>
	mk_keymap("n", "[c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "[c", bang = true })
		else
			require("gitsigns").nav_hunk("prev")
		end
	end, "Navigate to previous hunk (gitsigns)", "gitsigns"),
	mk_keymap("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Jump to previous diagnostic"),
	mk_keymap("n", "[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, "Jump to previous error diagnostic"),
	-- <=== end of [-key lhs ===>

	-- ===> start of <leader>? lhs ===>
	mk_keymap("n", "<leader>?", function()
		require("which-key").show({ global = false })
	end, { desc = "Buffer Local Keymaps (which-key)" }, "which-key"),
	-- <=== end of <leader>? lsh <===

	-- ===> start of <leader>c lhs ===>
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
	mk_keymap("n", "<leader>cF", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, "Format code (conform.nvim)", "conform"),
	mk_keymap("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (trouble.nvim)", "trouble"),
	mk_keymap(
		"n",
		"<leader>cS",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		"LSP Definitions / References / ... (trouble.nvim)",
		"trouble"
	),
	-- <=== end of <leader>c lhs ===>

	-- ===> start of <leader>d lhs ===>
	mk_keymap("n", "<leader>db", function()
		require("dap").toggle_breakpoint()
	end, { desc = "Toggle breakpoint (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dc", function()
		require("dap").continue()
	end, { desc = "Run/Continue the program's execution (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dC", function()
		require("dap").run_to_cursor()
	end, { desc = "Continue execution to the current cursor (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>di", function()
		require("dap").step_into()
	end, { desc = "Step into a function or method if possible (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dO", function()
		require("dap").step_over()
	end, { desc = "Step over a function or method (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dP", function()
		require("dap").pause()
	end, { desc = "Pause current thread (nvim-dap)" }, "nvim-dap"),
	mk_keymap("n", "<leader>dt", function()
		require("dap").terminate()
	end, { desc = "Terminate the debug session (nvim-dap)" }, "nvim-dap"),
	-- <=== end of <leader>d lhs ===>

	-- ===> start of <leader>f lhs ===>
	mk_keymap("n", "<leader>fb", function()
		require("telescope.builtin").buffers()
	end, "Buffers files (telescope)", "telescope"),
	mk_keymap("n", "<leader>ff", function()
		require("telescope.builtin").find_files()
	end, "Find files (telescope)", "telescope"),
	mk_keymap("n", "<leader>fg", function()
		require("telescope.builtin").live_grep()
	end, "Live grep (telescope)", "telescope"),
	mk_keymap("n", "<leader>fh", function()
		require("telescope.builtin").help_tags()
	end, "Help tags (telescope)", "telescope"),
	-- <=== end of <leader>f lhs <===

	-- ===> start of <leader>g lhs ===>
	-- <=== end of <leader>g lhs <===

	-- ===> start of <leader>h lhs ===>
	mk_keymap("n", "<leader>hb", function()
		require("gitsigns").blame_line({ full = true })
	end, "Run git blame on the current line and show the results in a floating window (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hd", function()
		require("gitsigns").diffthis()
	end, "Perform a `vimdiff` on the given file against the index (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hD", function()
		require("gitsigns").diffthis("~")
	end, "Perform a `vimdiff` on the given file previous commit (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hi", function()
		require("gitsigns").preview_hunk_inline()
	end, "Preview the hunk at the cursor position inline in the buffer (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hp", function()
		require("gitsigns").preview_hunk()
	end, "Preview the hunk at the cursor position in a floating window (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hq", function()
		require("gitsigns").setqflist()
	end, "Populate the quickfix list with hunks from the current buffer (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hQ", function()
		require("gitsigns").setqflist("all")
	end, "Populate the quickfix list with hunks from all files in the current working directory (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hr", function()
		require("gitsigns").reset_hunk()
	end, "Reset hunk on current cursor or range (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hR", function()
		require("gitsigns").reset_buffer()
	end, "Reset all hunks in current buffer (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hs", function()
		require("gitsigns").stage_hunk()
	end, "Stage hunk on current cursor or range (gitsigns)", "gitsigns"),
	mk_keymap("n", "<leader>hS", function()
		require("gitsigns").stage_buffer()
	end, "Stage all hunks in current buffer (gitsigns)", "gitsigns"),

	mk_keymap("v", "<leader>hr", function()
		require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "Reset hunk on current cursor or range (gitsigns)", "gitsigns"),
	mk_keymap("v", "<leader>hs", function()
		require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "Stage hunk on current cursor or range (gitsigns)", "gitsigns"),
	-- <=== end of <leader>h lhs <===

	-- ===> start of <leader>l lhs ===>
	mk_keymap("n", "<leader>li", function()
		require("lint").try_lint()
	end, { desc = "Try linting (nvim-lint)" }, "nvim-lint"),
	-- <=== end of <leader>l lhs <===

	-- ===> start of <leader>r lhs ===>
	mk_keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol (LSP)" }, "nvim-lspconfig-common"),
	-- <=== end of <leader>r lhs <===

	-- ===> start of <leader>t lhs ===>
	mk_keymap("n", "<leader>tl", "<cmd>TestLast<cr>", "Run the last test(vim-test)", "vim-test"),
	mk_keymap("n", "<leader>tr", "<cmd>TestNearest<cr>", "Run test nearest to the cursor (vim-test)", "vim-test"),
	mk_keymap("n", "<leader>tt", "<cmd>TestFile<cr>", "Run all tests in the current file (vim-test)", "vim-test"),
	mk_keymap("n", "<leader>tT", "<cmd>TestSuite<cr>", "Run the whole test suite (vim-test)", "vim-test"),
	mk_keymap(
		"n",
		"<leader>tv",
		"<cmd>TestVisit<cr>",
		"Visit the test file from which you last ran tests (vim-test)",
		"vim-test"
	),
	-- <=== end of <leader>t lhs <===

	-- ===> start of <leader>x lhs ===>
	mk_keymap("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (trouble.nvim)", "trouble"),
	mk_keymap("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (trouble.nvim)", "trouble"),
	mk_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Toggle diagnostics (trouble.nvim)", "trouble"),
	mk_keymap(
		"n",
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		"Buffer diagnostics (trouble.nvim)",
		"trouble"
	),
	-- <=== end of <leader>x lhs <===
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
--- Extra options can be passed to `extra_keymapset_opts` (e.g. buffer).
---
---@param ns string
---@param extra_keymapset_opts? config.mapping.ExtraKeymapsetOpts
function M.set_namespaced_keymaps(ns, extra_keymapset_opts)
	local keymaps = M.get_namespaced_keymaps(ns)
	for _, v in ipairs(keymaps) do
		---@type vim.keymap.set.Opts
		local opts = {}
		opts.desc = v.opts.desc
		opts.noremap = v.opts.noremap
		if extra_keymapset_opts ~= nil then
			if extra_keymapset_opts.buffer ~= nil then
				opts.buffer = extra_keymapset_opts.buffer
			end
		end
		vim.keymap.set(v.mode, v.lhs, v.rhs, opts)
	end
end

return M
