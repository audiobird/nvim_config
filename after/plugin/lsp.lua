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
end)

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- disable snippets!
capabilities.textDocument.completion.completionItem.snippetSupport = false

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'clangd',
        'gopls',
        'html',
    },
    handlers = {
        lsp.default_setup,
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
                    "--query-driver=/usr/bin/g*",
                    "--query-driver=/usr/bin/clang*",
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
        gopls = function()
            require('lspconfig').gopls.setup({
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    -- meh, doesn't seem to work templateExtensions = { "gohtml", "tmpl", "gotmpl", "tpl", "html" },
                },
            })
        end,
        tsserver = function()
            require('lspconfig').tsserver.setup({
                capabilities = capabilities,
                single_file_support = true,
            })
        end,
        html = function()
            require('lspconfig').html.setup({
                init_options = {
                    configurationSection = { "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                    provideFormatter = true,
                },
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
    }
})

-- auto diagnostic window. dont really like it anymore
--local function setup_lsp_diags()
--    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--        vim.lsp.diagnostic.on_publish_diagnostics,
--        {
--            virtual_text = false,
--            signs = true,
--            update_in_insert = false,
--            underline = true,
--        }
--    )
--end
--
--setup_lsp_diags()
--
--vim.o.updatetime = 150
--vim.api.nvim_create_autocmd({ "CursorHold" }, {
--    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
--    callback = function()
--        vim.diagnostic.open_float(nil,
--            { focusable = false, scope = "line", close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, focus = false })
--    end
--})
