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

	-- window navigation keymaps
	vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<cr>")
	vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<cr>")
	vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<cr>")
	vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<cr>")
end

function M.set_keys() end

return M
