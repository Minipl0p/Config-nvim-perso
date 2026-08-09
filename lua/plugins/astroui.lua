-- ============================================================
-- astroui.lua — UI, thème, icônes (AstroNvim v4)
-- ============================================================
return {
	"AstroNvim/astroui",
	---@type AstroUIOpts
	opts = {
		colorscheme = "catppuccin",
		-- Surcharges de highlights (optionnel)
		highlights = {
			-- Assure la cohérence du surlignage de yank
			YankHighlight = { bg = "#f38ba8", fg = "#1e1e2e" },
		},
	},
}
