local M = {}

local function mk_map(mode, lhs, rhs, opts, ns)
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
	mk_map("n", "<esc>", ":noh<cr><esc>", "Clear search highlight"),

	-- window navigation keymaps
	mk_map("n", "<c-k>", "<cmd>wincmd k<cr>", "Move to upwards window"),
	mk_map("n", "<c-j>", "<cmd>wincmd j<cr>", "Move to downwards window"),
	mk_map("n", "<c-h>", "<cmd>wincmd h<cr>", "Move to left window"),
	mk_map("n", "<c-l>", "<cmd>wincmd l<cr>", "Move to right window"),

	mk_map("n", "<leader>gf", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, "Format code (conform.nvim)", "conform"),
}

function M.get_namespaced(ns)
	local r = {}

	for _, m in ipairs(M.keys) do
		if m.ns == ns then
			table.insert(r, m)
		end
	end

	return r
end

return M
