vim.keymap.set("n", "<F7>", "<cmd>FloatermNew --height=1.0 --width=1.0 --disposable lazygit<CR>")

vim.keymap.set("n", "<F12>", "<cmd>FloatermToggle<CR>")
vim.api.nvim_set_keymap('t', '<F12>', '<C-\\><C-n>:FloatermToggle<CR>', {noremap = true, silent = true})

