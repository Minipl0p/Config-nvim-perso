-- ============================================================
-- buffers.lua — Keybinds <C-1>..<C-9> + commande :BufOrdinals
-- La logique est dans lua/lib/buffers.lua (module pur Lua).
-- ============================================================
-- Ce fichier est un plugin spec "virtuel" : il ne charge aucun
-- plugin externe, mais utilise l'astuce lazy `init` pour enregistrer
-- les raccourcis <C-1>..<C-9> dès le démarrage (Kitty/WezTerm).
return {
	-- On s'accroche à astrocore pour garder la cohérence
	"AstroNvim/astrocore",
	opts = function(_, opts)
		local maps = opts.mappings or {}
		maps.n    = maps.n or {}

		-- <C-1>..<C-9> (Kitty keyboard protocol)
		for i = 1, 9 do
			maps.n["<C-" .. i .. ">"] = {
				function() require("lib.buffers").close_ordinal(i) end,
				desc = "Fermer le buffer " .. i,
			}
		end

		opts.mappings = maps
		return opts
	end,
}
