return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    -- s : saut rapide (normal + visuel). PAS de mode "o" pour laisser
    -- l'operator-pending libre (surround cs/ds/ys viendra en Step 12).
    { "s", mode = { "n", "x" }, function() require("flash").jump() end, desc = "Flash jump" },
    -- S : saut sur des nœuds Treesitter (sélection de blocs de code).
    { "S", mode = { "n", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
  opts = {
    label = {
      uppercase = false, -- labels en minuscules, plus rapides à taper
    },
    modes = {
      -- Ne PAS activer le "jump label" pendant une recherche /,
      -- pour ne pas perturber ton flux de recherche habituel.
      search = { enabled = false },
      -- f/F/t/T restent le comportement Vim natif, mais Flash ajoute le
      -- repeat amélioré (optionnel). On laisse activé, c'est peu intrusif.
      char = { enabled = true },
    },
  },
}
