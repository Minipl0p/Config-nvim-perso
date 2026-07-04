return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim", -- provides git status shown in tabs
  },
  event = "VeryLazy",
  opts = {
    options = {
      mode = "buffers",
      numbers = "ordinal",             -- shows 1,2,3.. and renumbers dynamically
      diagnostics = "nvim_lsp",        -- error/warn badges per tab
      separator_style = "slant",       -- angled look (matches your screenshot)
      show_buffer_close_icons = false, -- clean, keyboard-driven
      show_close_icon = false,
      always_show_bufferline = true,
      -- Respect case as-is (bufferline shows the real filename; no lowercasing).
      -- Show git status indicators next to the name:
      -- (bufferline reads gitsigns; added/changed/removed reflected via highlights)
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- No keymaps here: buffer nav (H/L) and ordinal close (<C-1>..<C-9>)
    -- are centralized in lua/config/keybinds.lua (grouped by function).
  end,
}
