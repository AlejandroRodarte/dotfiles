local util = require("util")
local config = require("config")

return {
	build_opts = function(cmp)
		return {
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
					show_labelDetails = true,
					before = require("tailwind-tools.cmp").lspkind_format,
				}),
			},
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
				util.map_array_to_table(config.mapping.get_namespaced_keymaps("nvim-cmp"), "lhs", util.keymap_to_rhs)
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
