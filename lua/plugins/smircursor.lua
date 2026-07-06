return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- Traînée plus longue et plus "liquide" (plus vivante, sans exagérer).
		stiffness = 0.6,    -- plus bas = plus de traînée
		trailing_stiffness = 0.4, -- la queue met plus de temps à rattraper
		stiffness_insert_mode = 0.7,
		trailing_stiffness_insert_mode = 0.6,
		damping = 0.8,           -- plus bas = mouvement plus fluide/ample
		damping_insert_mode = 0.85,
		distance_stop_animating = 0.3, -- s'arrête proprement à l'arrivée
		-- Optionnel : couleur de la traînée (sinon suit le curseur).
		cursor_color = "#f38ba8", -- rose catppuccin (décommente pour tester)
	},
}
