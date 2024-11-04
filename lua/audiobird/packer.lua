vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use {
        "chrisgrieser/nvim-early-retirement",
        config = function()
            require("early-retirement").setup({
                retirementAgeMins = 10,
            })
        end,
    }
    use('nvim-treesitter/playground')
    use("nvim-treesitter/nvim-treesitter-context");
    use('theprimeagen/harpoon')
    use('RRethy/base16-nvim')
    use('hiphish/rainbow-delimiters.nvim')
    use('mbbill/undotree')
    use('voldikss/vim-floaterm')

    use { "L3MON4D3/LuaSnip", tag = "v2.*", run = "make install_jsregexp" }
    use('rafamadriz/friendly-snippets')
    use('saadparwaiz1/cmp_luasnip')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },

            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-calc' },
            { 'hrsh7th/cmp-buffer' },
        }
    }
end)
