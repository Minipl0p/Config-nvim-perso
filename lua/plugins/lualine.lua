return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            fmt = string.lower,
            -- theme = 'nightfly',
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
            always_divide_middle = false,
            globalstatus = false,
        },
        -- Adding things to the bottom bar
        sections = {
            lualine_a = {
                { 'mode', fmt = function(str) return str:sub(1,1) end }
            },
            lualine_x = {
                 'selectioncount', 'filetype', 'lsp_status'
            },
        },
        -- Adding things to the top bar
        tabline = {
            lualine_a = { { 'buffers', hide_filename_extension = true, } },
            lualine_x = { { 'datetime', style = "%H:%M", } }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}
