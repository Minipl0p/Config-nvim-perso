return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		-- Active uniquement ce qui ne conflict pas
		indent    = { enabled = true },
		scroll    = { enabled = true },
		words     = { enabled = true },
		lazygit   = { enabled = true },
		terminal  = {
			enabled = true,
			win = {
				position = "bottom",   -- split horizontal en bas (plus de float)
				height = 0.1,          -- ~30% de la hauteur de l'écran
			},
		},

		-- Désactive ce qui conflict avec d'autres plugins
		notifier  = { enabled = false },
		picker    = { enabled = false },
		dashboard = { enabled = false },
	},
}
