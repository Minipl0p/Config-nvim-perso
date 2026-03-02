return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        -- fallback "force" au moment où le client s'attache
        ["*"] = function(_, _)
          vim.lsp.inlay_hint.enable(false)
          return false
        end,
      },
    },
  },
}
