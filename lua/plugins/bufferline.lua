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
      hover = {                        -- info-bulle souris (n'affecte pas le clavier)
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      indicator = {                    -- barre visuelle sur le buffer actif
        style = "underline",
      },
      -- Nombre d'erreurs/warnings par onglet (plus lisible que le badge brut).
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. count .. icon
      end,
      -- IMPORTANT : masque les buffers terminaux (snacks) de la bufferline.
      -- Sans ça, un terminal pourrait apparaître comme onglet numéroté et
      -- décaler les ordinaux <C-1>..<C-9> (qui doivent cibler tes fichiers).
      custom_filter = function(buf_number)
        if vim.bo[buf_number].buftype == "terminal" then
          return false
        end
        return true
      end,
      -- Respect case as-is (bufferline shows the real filename; no lowercasing).
      -- Git status indicators are read from gitsigns (added/changed/removed).
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- No keymaps here: buffer nav (H/L) and ordinal close (<C-1>..<C-9>)
    -- are centralized in lua/config/keybinds.lua (grouped by function).
  end,
}
