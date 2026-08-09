-- ============================================================
-- markdown.lua — render-markdown + markdown-preview
-- ============================================================
-- render-markdown est déjà importé via astrocommunity.pack.markdown.
-- Ce fichier surcharge sa config et ajoute markdown-preview.
return {
	-- Surcharge render-markdown pour activer tous les éléments visuels
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			heading = {
				enabled = true,
				sign    = true,
				icons   = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
			},
			checkbox  = { enabled = true },
			pipe_table = { enabled = true },
			code      = { enabled = true, sign = false },
		},
	},

	-- markdown-preview : aperçu dans le navigateur
	{
		"iamcco/markdown-preview.nvim",
		cmd  = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft   = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
}
