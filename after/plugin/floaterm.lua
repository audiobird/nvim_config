vim.keymap.set("n", "<C-t>", "<cmd>FloatermToggle<CR>")
vim.api.nvim_set_keymap('t', '<C-t>', '<C-\\><C-n>:FloatermToggle<CR>', {noremap = true, silent = true})
