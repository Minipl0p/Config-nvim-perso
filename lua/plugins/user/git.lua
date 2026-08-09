-- ============================================================
-- git.lua — Diffview + Git-conflict (overrides depuis community)
-- ============================================================
-- diffview-nvim et git-conflict-nvim sont déjà importés via community.lua
-- Ce fichier ajoute uniquement les overrides nécessaires.
return {
	-- Diffview : surcharge pour s'assurer que les keymaps sont cohérents
	{
		"sindrets/diffview.nvim",
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
			},
		},
	},

	-- Git-conflict : override pour les couleurs / comportement
	{
		"akinsho/git-conflict.nvim",
		opts = {
			default_mappings = true,
			disable_diagnostics = true,
		},
	},
}
