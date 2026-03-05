return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({
						source = "filesystem",
						focus = true,
						reveal = true,
						position = "float",
					})
				end,
				desc = "Neo-tree focus (float)",
			},
		},
		opts = {
			window = {
				position = "float",
				width = 40,
				mappings = {
					-- l : ouvrir fichier ou dossier
					["l"] = "open",
					-- désactiver mappings par défaut si besoin
					["H"] = false,
					["L"] = false,
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		},
	},
}
