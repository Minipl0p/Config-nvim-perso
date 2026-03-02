return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Affiche les caractères invisibles
      -- (tu peux toggle avec :set list / :set nolist)
      defaults = {
        -- Certaines versions de LazyVim utilisent vim.opt directement,
        -- donc on met aussi un config ci-dessous pour être sûr.
      },
    },
    config = function()
      vim.opt.list = true
      vim.opt.listchars = {
        tab = "»·", -- une tab = » + un point (visible)
        trail = "·", -- trailing spaces (espaces en fin de ligne)
        extends = "›", -- ligne trop longue vers la droite
        precedes = "‹", -- ligne trop longue vers la gauche
        nbsp = "␣", -- espace insécable
      }
    end,
  },
}
