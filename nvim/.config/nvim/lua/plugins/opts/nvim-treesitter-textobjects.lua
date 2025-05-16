local config = require("config")
local util = require("util")

return {
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
			["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
			["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
			["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

			["a/"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
			["i/"] = { query = "@comment.inner", desc = "Select inner part of a comment" },

			["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
			["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

			["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

			["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
			["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

			["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
			["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

			["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
			["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

			["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
			["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

			-- @property capture groups are currently only defined in after/queries/ecma/textobjects.scm
			-- therefore, these keymaps only work for languages that extend from ecma (e.g. javascript, typescript)
			["ap"] = { query = "@property.outer", desc = "Select outer part of an object property" },
			["ip"] = { query = "@property.inner", desc = "Select inner part of an object property" },
			["lp"] = { query = "@property.lhs", desc = "Select left part of an object property" },
			["rp"] = { query = "@property.rhs", desc = "Select right part of an object property" },
		},
	},
	swap = {
		enable = true,
		swap_next = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-swap-next"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_swap_spec
		),
		swap_previous = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-swap-previous"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_swap_spec
		),
	},
	move = {
		enable = true,
		set_jumps = true,
		goto_next_start = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-goto-next-start"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_move_spec
		),
		goto_next_end = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-goto-next-end"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_move_spec
		),
		goto_previous_start = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-goto-previous-start"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_move_spec
		),
		goto_previous_end = util.map_array_to_table(
			config.mapping.get_namespaced_keymaps("nvim-treesitter-textobjects-goto-previous-end"),
			function(keymap)
				return keymap.lhs
			end,
			util.keymap_to_nvimtreesittertextobjects_move_spec
		),
	},
}
