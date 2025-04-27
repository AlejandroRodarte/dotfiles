local M = {}

function M.map(tbl, f)
	local r = {}
	for _, x in ipairs(tbl) do
		table.insert(r, f(x))
	end
	return r
end

function M.key_to_lazyspec(key)
	return { key.lhs, key.rhs, mode = key.mode, desc = key.opts.desc }
end

return M
