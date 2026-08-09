-- ============================================================
-- editing.lua — Flash, surround, yanky, rainbow, smear-cursor
-- ============================================================
return {
	-- Flash : navigation rapide dans le fichier
	-- (déjà importé via community, juste vérification de présence)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts  = {},
	},

	-- Surround : entourer/modifier les délimiteurs
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts  = {},
	},

	-- Yanky : historique clipboard
	{
		"gbprod/yanky.nvim",
		event = "VeryLazy",
		keys = {
			{ "p",    "<Plug>(YankyPutAfter)",        mode = { "n", "x" }, desc = "Coller après (yanky)" },
			{ "P",    "<Plug>(YankyPutBefore)",       mode = { "n", "x" }, desc = "Coller avant (yanky)" },
			{ "y",    "<Plug>(YankyYank)",             mode = { "n", "x" }, desc = "Yank (ring)" },
			{ "<C-p>", "<Plug>(YankyPreviousEntry)",  desc = "Yank précédent (cycle)" },
			{ "<C-n>", "<Plug>(YankyNextEntry)",      desc = "Yank suivant (cycle)" },
		},
		opts = {
			ring = {
				history_length  = 3,
				storage         = "memory",
				ignore_registers = { "_" },
			},
			highlight = {
				on_put  = true,
				on_yank = false,  -- l'autocmd YankHighlight s'en charge
				timer   = 130,
			},
		},
	},

	-- Rainbow : délimiteurs colorés selon la profondeur
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = {
					[""] = rainbow.strategy["global"],
				},
				query = {
					[""] = "rainbow-delimiters",
				},
			})
		end,
	},

	-- Smear cursor : curseur animé
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {
			stiffness                      = 0.6,
			trailing_stiffness             = 0.4,
			stiffness_insert_mode          = 0.7,
			trailing_stiffness_insert_mode = 0.6,
			damping                        = 0.8,
			damping_insert_mode            = 0.85,
			distance_stop_animating        = 0.3,
			cursor_color                   = "#f38ba8",
		},
	},
}
