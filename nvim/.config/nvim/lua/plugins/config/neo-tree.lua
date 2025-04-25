-- keymaps
-- `<C-n>`, `+`, and `j`, are all synonyms for the same command: move the cursor down one line
-- however, we really only need `j` to do this action
-- therefore, it's perfectly fine to use `+` as a namespace or custom mappings, or `<C-n>`
-- as a prefix for `<C-n> + {key}` mappings
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { desc = ":Neotree filesystem reveal left" })
