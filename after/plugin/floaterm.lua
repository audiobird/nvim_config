vim.keymap.set("n", "<F12>", "<cmd>FloatermToggle<CR>")
vim.api.nvim_set_keymap('t', '<F12>', '<C-\\><C-n>:FloatermToggle<CR>', {noremap = true, silent = true})

