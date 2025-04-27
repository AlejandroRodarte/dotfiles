local M = {}

M.mapping = require("config.mapping")

function M.setup(opts)
	-- global vim settings
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"

	-- vim options
	vim.opt.expandtab = true
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.number = true
	vim.opt.relativenumber = true

end

-- add non-namespaced keymaps
function M.set_keys()
  for i, v in ipairs(M.mapping.keys) do
    if v.ns == nil then
      vim.keymap.set(v.mode, v.lhs, v.rhs, v.opts)
    end
  end
end

return M
