-- ============================================================
-- terminal.lua — Terminal float centré (snacks.nvim override)
-- ============================================================
return {
	"folke/snacks.nvim",
	opts = {
		indent  = { enabled = true },
		scroll  = { enabled = true },
		words   = { enabled = true },
		lazygit = { enabled = true },
		terminal = {
			enabled = true,
			win = {
				position = "float",
				border   = "rounded",
				-- Float centré, taille raisonnable
				height   = 0.8,
				width    = 0.8,
				row      = 0.1,
				col      = 0.1,
			},
		},
		-- Désactive ce qui est géré par d'autres plugins
		notifier  = { enabled = false },
		picker    = { enabled = false },
		dashboard = { enabled = false },
	},
}
