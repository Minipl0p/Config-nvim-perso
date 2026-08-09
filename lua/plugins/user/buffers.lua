-- ============================================================
-- buffers.lua — Assure le chargement de lua/lib/buffers.lua
-- Les keybinds (<leader>1..<leader>9, <C-1>..<C-9>, <C-q>, etc.)
-- et la commande :BufOrdinals sont tous définis dans astrocore.lua.
-- Ce fichier charge la bibliothèque tôt pour que la commande
-- :BufOrdinals soit disponible dès le démarrage.
-- ============================================================
return {
	"AstroNvim/astrocore",
	init = function()
		-- Charge le module buffers dès le démarrage pour enregistrer
		-- la commande user :BufOrdinals (définie dans lua/lib/buffers.lua).
		require("lib.buffers")
	end,
}
