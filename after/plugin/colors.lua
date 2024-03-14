-- Default options:
require("gruvbox").setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {
        dark0_hard = "#0d1011",
        dark1 = "#2c2826",
        dark2 = "#403935",
        dark3 = "#564c44",
        dark4 = "#6c5f54",
        light0_hard = "#f9f5d7",
        light1 = "#fbebc2",
        light2 = "#e5d4b1",
        light3 = "#cdbea3",
        light4 = "#b8a994",
    },
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")
