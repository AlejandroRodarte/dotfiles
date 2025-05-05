local config = require("config")

return {
	on_attach = function(bufnr)
		local keymaps = config.mapping.get_namespaced_keymaps("gitsigns")
		for _, keymap in ipairs(keymaps) do
			vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, {
				desc = keymap.opts.desc,
				noremap = keymap.opts.noremap,
				buffer = bufnr,
			})
		end
	end,
}
