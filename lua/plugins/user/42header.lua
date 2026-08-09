-- ============================================================
-- 42header.lua — Header 42 (Diogo-ss/42-header.nvim)
-- ============================================================
return {
	"Diogo-ss/42-header.nvim",
	cmd = { "Stdheader" },
	opts = {
		default_map = true,   -- <F1> en mode normal
		auto_update = true,   -- mise à jour auto à la sauvegarde
		user = "ncorrear",
		mail = "marvin@42.fr",
	},
	config = function(_, opts)
		require("42header").setup(opts)
	end,
}
