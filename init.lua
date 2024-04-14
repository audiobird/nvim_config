require("audiobird")

-- stop auto comment when new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- W == w
vim.cmd([[command! W  write]])

vim.g.python3_host_prog = "$HOME/.python3_venv/bin/python3"
