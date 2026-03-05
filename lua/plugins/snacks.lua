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
				position = "float",       -- pour fenêtre flottante
				border = "rounded",       -- look sympa
				width = 0.8,
				height = 0.8,
			},
		},

		-- Désactive ce qui conflict avec d'autres plugins
		notifier  = { enabled = false },
		picker    = { enabled = false },
		dashboard = { enabled = false },
	},
}
