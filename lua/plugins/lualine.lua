return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            fmt = string.lower,
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            always_divide_middle = false,
            globalstatus = false,
        },
        -- Bottom bar
        sections = {
            lualine_a = {
                { 'mode', fmt = function(str) return str:sub(1,1) end }
            },
            lualine_x = {
                 'selectioncount', 'filetype', 'lsp_status'
            },
        },
        -- Top tab bar is now handled by bufferline.nvim (removed lualine tabline).
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}
