local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
      vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr})
end)

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- disable snippets!
capabilities.textDocument.completion.completionItem.snippetSupport = false

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'clangd'},
    handlers = {
        lsp_zero.default_setup,
        clangd = function()
            require('lspconfig').clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--pretty",
                    "--fallback-style=LLVM",
                    "--header-insertion=iwyu",
                    "--header-insertion-decorators",
                    "--completion-style=bundled",
                    "--query-driver=/usr/share/*-arm-none-eabi*/bin/arm-none-eabi-g*",
                    "--query-driver=/Users/**/bin/*-arm-none-eabi*/bin/arm-none-eabi-*",
                    "--query-driver=/usr/bin/g*",
                    "--query-driver=/usr/bin/clang*",
                    "--pch-storage=memory",
                    "--enable-config"
                },
                filetypes = { "c", "c++", "cpp" },
            })
        end,
        tsserver = function()
            require('lspconfig').tsserver.setup({
                capabilities = capabilities,
                single_file_support = true,
            })
        end
    },
})

lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['clangd'] = { 'cpp' },
        ['tsserver'] = { 'javascript', 'typescript' },
        ['rust_analyzer'] = { 'rust' },
        ['gopls'] = { 'go' },
    }
})

local function setup_lsp_diags()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    }
  )
end

setup_lsp_diags()

vim.o.updatetime = 150
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

