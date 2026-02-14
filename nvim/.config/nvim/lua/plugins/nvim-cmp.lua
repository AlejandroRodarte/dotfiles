local util = require("util");
local config = require("config");

return {
	"hrsh7th/nvim-cmp",
	config = function(lazyplugin, opts)
		local cmp = require("cmp")
    cmp.setup({
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
					show_labelDetails = true,
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
				util.map_array_to_table(config.mapping.get_namespaced_keymaps("nvim-cmp"), function(keymap)
					return keymap.lhs
				end, util.keymap_to_rhs)
			),
			sources = cmp.config.sources({
				{
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading luals completions
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "nvim_lsp_signature_help" },
			}, {
				{ name = "buffer" },
			}),
		})
	end,
}
