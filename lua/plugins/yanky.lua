return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	keys = {
		-- Coller via yanky (alimente le ring). Normal + visuel.
		{ "p", "<Plug>(YankyPutAfter)",  mode = { "n", "x" }, desc = "Coller après (yanky)" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Coller avant (yanky)" },
		-- Enregistre tous les yanks dans le ring (y, yy, yiw...).
		{ "y", "<Plug>(YankyYank)",      mode = { "n", "x" }, desc = "Yank (dans le ring)" },
		-- Cycle CYCLIQUE dans le ring, juste après un collage :
		--   <C-p> = entrée précédente (plus ancienne), boucle après la fin
		--   <C-n> = entrée suivante (plus récente), boucle aussi
		{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Yank précédent (cycle)" },
		{ "<C-n>", "<Plug>(YankyNextEntry)",     desc = "Yank suivant (cycle)" },
	},
	opts = {
		ring = {
			history_length = 3,     -- ring limité aux 3 derniers yanks
			storage = "memory",     -- repart propre à chaque session (pas de clean)
			ignore_registers = { "_" },
		},
		highlight = {
			on_put = true,          -- surligne le texte collé
			on_yank = false,        -- ton YankHighlight (options.lua) gère le yank
			timer = 130,
		},
	},
}
