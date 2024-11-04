vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require('luasnip.loaders.from_vscode').lazy_load()

local lsp = require('lsp-zero')

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        local bufmap = function(mode, lhs, rhs)
            local opts = { buffer = true }
            vim.keymap.set(mode, lhs, rhs, opts)
        end


        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        bufmap('n', 'gi', '<cmd>Telescope lsp_implementations<cr>')
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        bufmap('n', 'gr', '<cmd>Telescope lsp_references<cr>')
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        bufmap('n', '<leader>as',
            '<cmd>lua if vim.b.lsp_zero_enable_autoformat == 0 then vim.b.lsp_zero_enable_autoformat = 1 else vim.b.lsp_zero_enable_autoformat = 0 end<cr>')
    end
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.extend_lspconfig({
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»',
    },
    capabilities = capabilities,
    float_border = 'rounded',
})

require('lspconfig').clangd.setup({
    capabilities = capabilities,
    init_options = { fallbackFlags = { '-std=gnu++2b' } },
    cmd = {
        "/usr/bin/clangd",
        "--background-index",
        "--clang-tidy",
        "--pretty",
        "--fallback-style=LLVM",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--completion-style=bundled",
        "--query-driver=" .. os.getenv("HOME") .. "/.gcc/12.3/bin/arm-none-eabi-*",
        "--query-driver=" .. os.getenv("HOME") .. "/.gcc/13.2/bin/arm-none-eabi-*",
        "--query-driver=/usr/bin/g*",
        "--pch-storage=memory",
        "--enable-config",
    },
    filetypes = { "c", "c++", "cpp" },
    root_dir = require('lspconfig').util.root_pattern("build/compile_commands.json", "compile_commands.json"),
})

require("mason").setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'gopls',
        'html',
        'tailwindcss',
        'htmx',
        'templ',
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                capabilities = capabilities,
                root_dir = require('lspconfig').util.find_git_ancestor,
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
        ['lua_ls'] = { 'lua' },
        ['templ'] = { 'templ' },
        ['html'] = { 'html' },
        ['ts_ls'] = { 'javascript' },
    }
})
