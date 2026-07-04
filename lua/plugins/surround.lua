return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	opts = {},
	-- Défauts : ys{motion}{char} ajoute, ds{char} supprime, cs{old}{new} change.
	-- Ex: ysiw"  entoure le mot de "guillemets"  |  ds"  retire  |  cs"'  " -> '
}
