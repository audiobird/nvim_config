require("audiobird")

-- stop auto comment when new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- W == w
vim.cmd([[command! W  write]])

