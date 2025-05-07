---@class util.LazyKey
---@field [0] string
---@field [1] string | function
---@field mode string[]
---@field desc string

local M = {}

---
--- Maps the items of array (indexed table) `arr` with mapper function `f`.
--- Array items of original type `T` are "mapped" into items of mapped type `B`.
---
---@generic T, B
---@param arr T[]
---@param f fun(item: T): B
---@return B[]
function M.map_array(arr, f)
	local r = {}
	for _, x in ipairs(arr) do
		table.insert(r, f(x))
	end
	return r
end

---
--- Maps a `config.mapping.KeyMap` instance (constructed by the `mk_keymap` function)
--- into a `util.LazyKey` entry, compliant with the `keys` property from the
--- [Lazy Loading Spec](https://lazy.folke.io/spec#spec-lazy-loading)
---
---@param keymap config.mapping.KeyMap
---@return util.LazyKey
function M.keymap_to_lazykey(keymap)
	return { keymap.lhs, keymap.rhs, mode = keymap.mode, desc = keymap.opts.desc }
end

---
--- Maps an `arr` array of items of type `T` into a table.
--- If a mapping function `f` is provided, items of type `T`
--- are "mapped" into items of type `B`.
---
--- Each `item` of type `T` must be a table with a named field `key`
--- that corresponds to a unique value across all the items in the original array `arr`.
--- This is because items in the output table (`item` or `f(item)`) will be accessed using
--- this unique `item[key]` value.
---
---@generic T: table, B
---@param arr T[]
---@param key string
---@param f? fun(T): B
function M.map_array_to_table(arr, key, f)
	local r = {}
	for _, x in ipairs(arr) do
		if f ~= nil then
			r[x[key]] = f(x)
		else
			r[x[key]] = x
		end
	end
	return r
end

---
--- Get the `rhs` value out of a `config.mapping.KeyMap` instance.
---
--- @param keymap config.mapping.KeyMap
--- @return config.mapping.KeyMap.Rhs
function M.keymap_to_rhs(keymap)
	return keymap.rhs
end

return M
