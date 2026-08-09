-- ============================================================
-- yazi.lua — Intégration yazi.nvim avec changement de root
-- ============================================================
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>y",
			function() require("yazi").yazi() end,
			desc = "Yazi : fichier courant",
		},
		{
			"<leader>Y",
			function() require("yazi").yazi(nil, vim.fn.getcwd()) end,
			desc = "Yazi : répertoire de travail",
		},
		{
			"<C-y>",
			function() require("yazi").toggle() end,
			desc = "Yazi : toggle dernier",
		},
	},
	opts = {
		open_for_directories = true,
		future_features = {
			-- Sync le cwd global de Neovim quand on navigue dans Yazi
			ya_emit_reveal = true,
		},
		keymaps = {
			show_help = "<f1>",
		},
	},
}
