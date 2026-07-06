return {
	"HiPhish/rainbow-delimiters.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local rd = require("rainbow-delimiters")
		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = rd.strategy["global"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks", -- en Lua, colore aussi les blocs (do/end...)
			},
			-- Couleurs cyclées pour les niveaux d'imbrication (teintes catppuccin).
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		})
	end,
}
