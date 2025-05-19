---@class config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects.Move
---@field query string
---@field query_group? string

---@class config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects.Swap
---@field query string

---@class config.mapping.KeyMap.PluginSpecs.NvimTreesitter.IncrementalSelection
---@field action string

---@class config.mapping.KeyMap.PluginSpecs.NvimTreesitter
---@field incremental_selection? config.mapping.KeyMap.PluginSpecs.NvimTreesitter.IncrementalSelection

---@class config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects
---@field swap? config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects.Swap
---@field move? config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects.Move

---@class config.mapping.KeyMap.PluginSpecs
---@field nvim_treesitter? config.mapping.KeyMap.PluginSpecs.NvimTreesitter
---@field nvim_treesitter_textobjects? config.mapping.KeyMap.PluginSpecs.NvimTreesitterTextobjects

---@class config.mapping.ExtraKeymapsetOpts
---@field buffer? number

---@alias config.mapping.KeyMap.Rhs string | function
---@alias config.mapping.KeyMap.Lhs string
---@alias config.mapping.KeyMap.Opts { desc: string, noremap: boolean, expr?: boolean }

---@class config.mapping.KeyMap
---@field mode string[]
---@field lhs string
---@field rhs config.mapping.KeyMap.Rhs
---@field opts { desc: string, noremap: boolean }
---@field ns string
---@field plugin_specs? config.mapping.KeyMap.PluginSpecs

local M = {}

---
--- Generate a table of type `config.mapping.KeyMap`.
---
---@param mode string | string[]
---@param lhs config.mapping.KeyMap.Lhs
---@param rhs config.mapping.KeyMap.Rhs
---@param opts string | config.mapping.KeyMap.Opts
---@param ns? string
---@param plugin_specs? config.mapping.KeyMap.PluginSpecs
---@return config.mapping.KeyMap
local function mk_keymap(mode, lhs, rhs, opts, ns, plugin_specs)
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
		plugin_specs = plugin_specs,
	}
end

-- before keymaps are defined, remove default LSP keymaps
vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")

-- ===> start of notes about keymaps ===>
-- 1. nvim-cmp keymap functions are called with a `fallback` function
--    provided by the library itself; this is needed for the plugin to work properly.
--    The code inside these keymap functions is derived from
--    [this source code file](https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua)
-- <=== end of notes about keymaps <===

M.keys = {
	-- ===> start of single-key lhs (e.g. <esc>, K, <cr>) ===>
	-- warning: overrides default vim behavior for <bs>: same as "h" in normal mode
	mk_keymap(
		"n",
		"<bs>",
		"",
		"Reduce selection to the child node in syntax tree (nvim-treesitter)",
		"nvim-treesitter-incremental-selection",
		{
			nvim_treesitter = {
				incremental_selection = {
					action = "node_decremental",
				},
			},
		}
	),
	mk_keymap("n", "<esc>", "<cmd>noh<cr><esc>", "Clear search highlight"),
	-- warning: overrides default vim behavior for -: cursor to the first CHAR N lines higher
	mk_keymap("n", "-", "<cmd>Oil<cr>", "Open parent directory (oil.nvim)", "oil"),

	mk_keymap(
		"n",
		"j",
		[[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']],
		{ desc = "Move cursor downards", noremap = true, expr = true }
	),
	mk_keymap(
		"n",
		"k",
		[[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']],
		{ desc = "Move cursor upwards", noremap = true, expr = true }
	),
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
	mk_keymap("n", "n", "nzzzv", "Next result, center cursor, and show cursor line"),
	mk_keymap("n", "N", "Nzzzv", "Previous result, center cursor, and show cursor line"),

	mk_keymap("i", "<cr>", function(fallback)
		if not require("cmp").confirm({ select = true }) then
			fallback()
		end
	end, "Select autocomplete option", "nvim-cmp"),
	-- <=== end of single-key lhs (e.g. <esc>, K, <cr>) <===

	-- ===> start of ctrl-key lhs (e.g. <c-n>, <c-j>) ===>
	mk_keymap(
		"n",
		"<c-space>",
		"",
		"Select current node in syntax tree (nvim-treesitter)",
		"nvim-treesitter-incremental-selection",
		{
			nvim_treesitter = {
				incremental_selection = {
					action = "init_selection",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"<c-space>",
		"",
		"Expand selection to the parent node in syntax tree (nvim-treesitter)",
		"nvim-treesitter-incremental-selection",
		{
			nvim_treesitter = {
				incremental_selection = {
					action = "node_incremental",
				},
			},
		}
	),

	mk_keymap("n", "<c-up>", "<cmd>resize +2<cr>", "Increase window height"),
	mk_keymap("n", "<c-down>", "<cmd>resize -2<cr>", "Decrease window height"),
	-- warning: overrides default vim behavior for <c-left>: same as "b" in normal mode
	mk_keymap("n", "<c-left>", "<cmd>vertical resize -2<cr>", "Decrease window width"),
	-- warning: overrides default vim behavior for <c-right>: same as "w" in normal mode
	mk_keymap("n", "<c-right>", "<cmd>vertical resize +2<cr>", "Increase window width"),

	mk_keymap("n", "<c-d>", "<c-d>zz", "Scroll downwards and center cursor"),
	mk_keymap("n", "<c-u>", "<c-u>zz", "Scroll upwards and center cursor"),

	-- warning: overrides default vim behavior for <c-h>: same as "h" in normal mode
	mk_keymap(
		"n",
		"<c-h>",
		"<cmd><c-u>TmuxNavigateLeft<cr>",
		"Navigate to left pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	-- warning: overrides default vim behavior for <c-h>: same as "j" in normal mode
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
	-- warning: overrides default vim behavior for <c-l>: redraw screen
	mk_keymap(
		"n",
		"<c-l>",
		"<cmd><c-u>TmuxNavigateRight<cr>",
		"Navigate to right pane (vim-tmux-navigator)",
		"vim-tmux-navigator"
	),
	-- warning: overrides default vim behavior for <c-n>: same as "j" in normal mode
	mk_keymap("n", "<c-n>", "<cmd>Neotree filesystem reveal left<cr>", "Open file explorer (to the left)", "neo-tree"),
	-- warning: overrides multiple default vim behaviors for <c-\\>:
	--          1. <c-\\> <c-n>: go to normal mode (no-op)
	--          2. <c-\\> <c-g>: go to mode specified with 'insertmode'
	--          3. <c-\\> a-z: reserved for extensions
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
	-- warning: overrides default vim behavior for <c-e>: insert the character which is below the cursor not used
	mk_keymap("i", "<c-e>", function(fallback)
		if not require("cmp").abort() then
			fallback()
		end
	end, "Close autocomplete window", "nvim-cmp"),
	-- warning: overrides default vim behavior for <c-f>: same as "<c-e>" in insert mode
	mk_keymap("i", "<c-f>", function(fallback)
		if not require("cmp").scroll_docs(4) then
			fallback()
		end
	end, "Scroll documentation upwards (nvim-cmp)", "nvim-cmp"),
	-- warning: overrides default vim behavior for <c-k>: enter digraph (<c-k> {char1} {char2})
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

	-- ===> start of shift-key lhs (e.g. <s-a>, <s-cr>) ===>
	-- <=== end of shift-key lhs (e.g. <s-a>, <s-cr>) <===

	-- ===> start of g-key lhs (alphabetically ordered) (e.g. gd, gK) ===>
	-- warning: overrides default vim behavior for gd: go to definition of work under the cursor in the current function
	mk_keymap(
		"n",
		"gd",
		vim.lsp.buf.definition,
		"Go to definition of symbol (using vim.lsp.buf API)",
		"nvim-lspconfig-common"
	),
	-- warning: overrides default vim behavior for gD: go to definition of work under the cursor in the current file
	mk_keymap("n", "gD", vim.lsp.buf.declaration, "Go to declaration (LSP)", "nvim-lspconfig-common"),
	-- warning: overrides default vim behavior for gi: like "i" in normal mode, but first move to the '^ mark before inserting
	mk_keymap("n", "gi", vim.lsp.buf.implementation, "Go to implementation (LSP)", "nvim-lspconfig-common"),
	mk_keymap("n", "gK", function()
		vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
	end, "Toggle virtual lines (global; applies to all diagnostic namespaces)"),
	-- warning: overrides default vim behavior for gr: virtual replace N chars with {char} (gr{char})
	mk_keymap(
		"n",
		"gr",
		vim.lsp.buf.references,
		"List all references in the quickfix window (LSP)",
		"nvim-lspconfig-common"
	),
	mk_keymap("n", "gy", vim.lsp.buf.type_definition, "Go to type definition (LSP)", "nvim-lspconfig-common"),
	-- <=== end of g-key lhs (alphabetically ordered) (e.g. gd, gK) <===

	-- ===> start of ]-key lhs ===>
	mk_keymap("n", "]<cr>", "m`o<esc>``", "Insert newline below cursor without leaving normal mode"),
	-- warning: overrides default vim behavior for ]c: cursor N times forward to start of change
	mk_keymap("n", "]c", "", "Go to start of next class definition", "nvim-treesitter-textobjects-goto-next-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@class.outer",
			},
		},
	}),
	mk_keymap("n", "]C", "", "Go to end of next class definition", "nvim-treesitter-textobjects-goto-next-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@class.outer",
			},
		},
	}),
	-- warning: overrides default vim behavior for ]d: show first #define found in current and included files matching the work under the cursor, start searching at cursor same as "gf"
	mk_keymap("n", "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Jump to next diagnostic"),
	mk_keymap("n", "]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, "Jump to next error diagnostic"),
	-- warning: overrides default vim behavior for ]f: same as "gf" in normal mode
	mk_keymap("n", "]f", "", "Go to start of next function call", "nvim-treesitter-textobjects-goto-next-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@call.outer",
			},
		},
	}),
	mk_keymap("n", "]F", "", "Go to end of next function call", "nvim-treesitter-textobjects-goto-next-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@call.outer",
			},
		},
	}),
	mk_keymap("n", "]h", function()
		require("gitsigns").nav_hunk("next")
	end, "Navigate to next hunk (gitsigns)", "gitsigns"),
	-- warning: overrides default vim behavior for ]i: show first line found in current and included files that contains the word under the cursor, start searching at cursor position
	mk_keymap("n", "]i", "", "Go to start of next conditional", "nvim-treesitter-textobjects-goto-next-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@conditional.outer",
			},
		},
	}),
	-- warning: overrides default vim behavior for ]I: list all lines found in current and included files that contain the work under the cursor, start searching at cursor position
	mk_keymap("n", "]I", "", "Go to end of next conditional", "nvim-treesitter-textobjects-goto-next-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@conditional.outer",
			},
		},
	}),
	mk_keymap("n", "]l", "", "Go to start of next loop", "nvim-treesitter-textobjects-goto-next-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@loop.outer",
			},
		},
	}),
	mk_keymap("n", "]L", "", "Go to end of next loop", "nvim-treesitter-textobjects-goto-next-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@loop.outer",
			},
		},
	}),
	-- warning: overrides default vim behavior for ]m: cursor N times forward to end of member function
	mk_keymap(
		"n",
		"]m",
		"",
		"Go to start of next method/function definition",
		"nvim-treesitter-textobjects-goto-next-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@function.outer",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"]M",
		"",
		"Go to end of next method/function definition",
		"nvim-treesitter-textobjects-goto-next-end",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@function.outer",
				},
			},
		}
	),
	-- warning: overrides default vim behavior for ]p: like "p", but adjust indent to current line
	mk_keymap("n", "]p", "", "Go to start of next field/property", "nvim-treesitter-textobjects-goto-next-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@property.outer",
			},
		},
	}),
	-- warning: overrides default vim behavior for ]P: same as "]p"
	mk_keymap("n", "]P", "", "Go to end of next field/property", "nvim-treesitter-textobjects-goto-next-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@property.outer",
			},
		},
	}), -- <=== end of ]-key lhs ===>

	-- ===> start of [-key lhs ===>
	mk_keymap("n", "[<cr>", "m`O<esc>``", "Insert newline above cursor without leaving normal mode"),
	-- warning: overrides default vim behavior for [c: cursor N times backwards to start of change
	mk_keymap(
		"n",
		"[c",
		"",
		"Go to start of previous class definition",
		"nvim-treesitter-textobjects-goto-previous-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@class.outer",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"[C",
		"",
		"Go to end of previous class definition",
		"nvim-treesitter-textobjects-goto-previous-end",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@class.outer",
				},
			},
		}
	),
	-- warning: overrides default vim behavior for [d: show first #define found in current and included files matching the word under the cursor, start searching at the beginning of current file
	mk_keymap("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Jump to previous diagnostic"),
	mk_keymap("n", "[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, "Jump to previous error diagnostic"),
	-- warning: overrides default vim behavior for [f: same as "gf" in normal mode
	mk_keymap(
		"n",
		"[f",
		"",
		"Go to start of previous function call",
		"nvim-treesitter-textobjects-goto-previous-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@call.outer",
				},
			},
		}
	),
	mk_keymap("n", "[F", "", "Go to end of previous function call", "nvim-treesitter-textobjects-goto-previous-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@call.outer",
			},
		},
	}),
	mk_keymap("n", "[h", function()
		require("gitsigns").nav_hunk("prev")
	end, "Navigate to previous hunk (gitsigns)", "gitsigns"),
	-- warning: overrides default vim behavior for [i: show first line found in current and included files that contains the word under the cursor, start searching at the beginning of the current file
	mk_keymap(
		"n",
		"[i",
		"",
		"Go to start of previous conditional",
		"nvim-treesitter-textobjects-goto-previous-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@conditional.outer",
				},
			},
		}
	),
	-- warning: overrides default vim behavior for [I: list all lines found in current and included files that contain the work under the cursor, start searching at the beginning of the current file
	mk_keymap("n", "[I", "", "Go to end of previous conditional", "nvim-treesitter-textobjects-goto-previous-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@conditional.outer",
			},
		},
	}),
	mk_keymap("n", "[l", "", "Go to start of previous loop", "nvim-treesitter-textobjects-goto-previous-start", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@loop.outer",
			},
		},
	}),
	mk_keymap("n", "[L", "", "Go to end of previous loop", "nvim-treesitter-textobjects-goto-previous-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@loop.outer",
			},
		},
	}),
	-- warning: overrides default vim behavior for [m: cursor N times back to start of member function
	mk_keymap(
		"n",
		"[m",
		"",
		"Go to start of previous method/function definition",
		"nvim-treesitter-textobjects-goto-previous-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@function.outer",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"[M",
		"",
		"Go to end of previous method/function definition",
		"nvim-treesitter-textobjects-goto-previous-end",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@function.outer",
				},
			},
		}
	),
	-- warning: overrides default vim behavior for [p: like "P", but adjust indend to current line
	mk_keymap(
		"n",
		"[p",
		"",
		"Go to start of previous field/property",
		"nvim-treesitter-textobjects-goto-previous-start",
		{
			nvim_treesitter_textobjects = {
				move = {
					query = "@property.outer",
				},
			},
		}
	),
	-- warning: overrides default vim behavior for [P: same as "[p"
	mk_keymap("n", "[P", "", "Go to end of previous field/property", "nvim-treesitter-textobjects-goto-previous-end", {
		nvim_treesitter_textobjects = {
			move = {
				query = "@property.outer",
			},
		},
	}), -- <=== end of [-key lhs ===>

	-- ===> start of <leader>? lhs ===>
	mk_keymap("n", "<leader>?", function()
		require("which-key").show({ global = false })
	end, "Buffer Local Keymaps (which-key)", "which-key"),
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
	end, "Toggle breakpoint (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>dc", function()
		require("dap").continue()
	end, "Run/Continue the program's execution (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>dC", function()
		require("dap").run_to_cursor()
	end, "Continue execution to the current cursor (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>di", function()
		require("dap").step_into()
	end, "Step into a function or method if possible (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>dO", function()
		require("dap").step_over()
	end, "Step over a function or method (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>dP", function()
		require("dap").pause()
	end, "Pause current thread (nvim-dap)", "nvim-dap"),
	mk_keymap("n", "<leader>dt", function()
		require("dap").terminate()
	end, "Terminate the debug session (nvim-dap)", "nvim-dap"),
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
	mk_keymap("n", "<leader>lg", function()
		require("snacks").lazygit()
	end, "Open Lazygit (snacks.nvim)", "snacks"),
	mk_keymap("n", "<leader>li", function()
		require("lint").try_lint()
	end, "Try linting (nvim-lint)", "nvim-lint"),
	-- <=== end of <leader>l lhs <===

	-- ===> start of <leader>n lhs ===>
	mk_keymap(
		"n",
		"<leader>na",
		"",
		"Swap parameters/arguments with the next occurrence of it (nvim-treesitter-textobjects)",
		"nvim-treesitter-textobjects-swap-next",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@parameter.inner",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"<leader>nm",
		"",
		"Swap function with the next occurrence of it (nvim-treesitter-textobjects)",
		"nvim-treesitter-textobjects-swap-next",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@function.outer",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"<leader>np",
		"",
		"Swap object property with the next occurrence of it (nvim-treesitter-textobjects; javascript/typescript only)",
		"nvim-treesitter-textobjects-swap-next",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@property.outer",
				},
			},
		}
	),
	-- <=== end of <leader>n lhs <===

	-- ===> start of <leader>p lhs ===>
	mk_keymap(
		"n",
		"<leader>pa",
		"",
		"Swap parameters/arguments with the previous occurrence of it (nvim-treesitter-textobjects)",
		"nvim-treesitter-textobjects-swap-previous",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@parameter.inner",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"<leader>pm",
		"",
		"Swap function with the previous occurrence of it (nvim-treesitter-textobjects)",
		"nvim-treesitter-textobjects-swap-previous",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@function.outer",
				},
			},
		}
	),
	mk_keymap(
		"n",
		"<leader>pp",
		"",
		"Swap object property with the previous occurrence of it (nvim-treesitter-textobjects; javascript/typescript only)",
		"nvim-treesitter-textobjects-swap-previous",
		{
			nvim_treesitter_textobjects = {
				swap = {
					query = "@property.outer",
				},
			},
		}
	),
	-- <=== end of <leader>p lhs <===

	-- ===> start of <leader>r lhs ===>
	mk_keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol (LSP)", "nvim-lspconfig-common"),
	-- <=== end of <leader>r lhs <===

	-- ===> start of <leader>t lhs ===>
	mk_keymap("n", "<leader>ta", "<cmd>TestSuite<cr>", "Run the whole test suite (vim-test)", "vim-test"),
	mk_keymap("n", "<leader>td", "<cmd>tabclose<cr>", "Close current tab"),
	mk_keymap("n", "<leader>tl", "<cmd>TestLast<cr>", "Run the last test(vim-test)", "vim-test"),
	mk_keymap("n", "<leader>tn", "<cmd>tabnew<cr>", "Create a new tab"),
	mk_keymap("n", "<leader>tt", "<cmd>TestNearest<cr>", "Run test nearest to the cursor (vim-test)", "vim-test"),
	mk_keymap("n", "<leader>tT", "<cmd>TestFile<cr>", "Run all tests in the current file (vim-test)", "vim-test"),
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
