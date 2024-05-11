local lsp = require('lsp-zero')

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
    vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', { buffer = bufnr })
end)

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- disable snippets!
-- capabilities.textDocument.completion.completionItem.snippetSupport = false

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',
        'gopls',
        'html',
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
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
                    "--query-driver=/usr/bin/arm-none-eabi-g*",
                    "--query-driver=/usr/bin/g*",
                    "--pch-storage=memory",
                    "--enable-config"
                },
                filetypes = { "c", "c++", "cpp" },
            })
        end,
        -- undefined vim error
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
        end,
    },
})

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['clangd'] = { 'cpp' },
        ['gopls'] = { 'go' },
        ['html'] = { 'html' },
        ['lua_ls'] = { 'lua' },
        ['templ'] = { 'templ' },
    }
})
