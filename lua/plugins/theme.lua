return {
  {
    "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("forestbones")

      -- Ardoise (plus neutre) + contraste net sur les floats
      local bg = "#0b0f0e" -- ardoise très sombre
      local bg2 = "#121917" -- cursorline / panels
      local floatbg = "#16201d" -- floats/menus (encore plus clair)
      local fg = "#f2f6f2" -- craie
      local dim = "#a7bdb2"
      local accent = "#8fe0c1"
      local hl = vim.api.nvim_set_hl

      -- Canvas
      hl(0, "Normal", { fg = fg, bg = bg })
      hl(0, "NormalNC", { fg = fg, bg = bg })
      hl(0, "EndOfBuffer", { fg = bg, bg = bg })
      hl(0, "SignColumn", { bg = bg })
      hl(0, "FoldColumn", { fg = dim, bg = bg })
      hl(0, "LineNr", { fg = dim, bg = bg })
      hl(0, "CursorLineNr", { fg = fg, bg = bg, bold = true })
      hl(0, "CursorLine", { bg = bg2 })
      hl(0, "ColorColumn", { bg = bg2 })
      hl(0, "Whitespace", { fg = "#22312d" })
      hl(0, "WinSeparator", { fg = "#2a3a35", bg = bg })

      -- Floats/menus (plus contrastés)
      hl(0, "NormalFloat", { fg = fg, bg = floatbg })
      hl(0, "FloatBorder", { fg = accent, bg = floatbg })
      hl(0, "Pmenu", { fg = fg, bg = floatbg })
      hl(0, "PmenuSel", { fg = bg, bg = accent, bold = true })
      hl(0, "PmenuSbar", { bg = "#1c2a26" })
      hl(0, "PmenuThumb", { bg = accent })

      -- Recherche
      hl(0, "Search", { fg = bg, bg = "#e6d36f", bold = true })
      hl(0, "IncSearch", { fg = bg, bg = "#ffe587", bold = true })

      -- Pastel palette (lisibilité)
      local pastel = {
        red = "#f2a6a6",
        orange = "#f2c1a0",
        yellow = "#f2e39c",
        green = "#aee6c5",
        cyan = "#9fe3e6",
        blue = "#a9c7ff",
        purple = "#d5b3ff",
        gray = "#b9c8bf",
      }

      hl(0, "Comment", { fg = pastel.gray, italic = true })
      hl(0, "String", { fg = pastel.green })
      hl(0, "Character", { fg = pastel.green })
      hl(0, "Number", { fg = pastel.orange })
      hl(0, "Float", { fg = pastel.orange })
      hl(0, "Boolean", { fg = pastel.orange })

      hl(0, "Function", { fg = pastel.blue, bold = true })
      hl(0, "Identifier", { fg = fg })
      hl(0, "Type", { fg = pastel.yellow })
      hl(0, "StorageClass", { fg = pastel.yellow })
      hl(0, "Structure", { fg = pastel.yellow })
      hl(0, "Typedef", { fg = pastel.yellow })

      hl(0, "Statement", { fg = pastel.purple, bold = true })
      hl(0, "Conditional", { fg = pastel.purple, bold = true })
      hl(0, "Repeat", { fg = pastel.purple, bold = true })
      hl(0, "Keyword", { fg = pastel.purple, bold = true })
      hl(0, "Operator", { fg = pastel.cyan })

      hl(0, "Constant", { fg = pastel.orange })
      hl(0, "Macro", { fg = pastel.red })
      hl(0, "PreProc", { fg = pastel.red })
      hl(0, "Include", { fg = pastel.red })

      hl(0, "DiagnosticError", { fg = pastel.red })
      hl(0, "DiagnosticWarn", { fg = pastel.yellow })
      hl(0, "DiagnosticInfo", { fg = pastel.blue })
      hl(0, "DiagnosticHint", { fg = pastel.cyan })
    end,
  },
}
