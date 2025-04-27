local util = require("util")
local config = require("config")

return {
	build_opts = function(cmp)
		return {
			snippet = {
				-- let luasnip handle snippet expansion
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert(
				util.map_array_to_table(config.mapping.get_namespaced("nvim-cmp"), "lhs", util.keymap_to_rhs)
			),
			sources = cmp.config.sources({
				{
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading luals completions
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		}
	end,
}
