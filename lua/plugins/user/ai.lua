-- ============================================================
-- ai.lua — Copilot (complétion inline) + Avante (chat IA)
-- ============================================================
return {
	-- Copilot : complétion inline
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled      = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
				},
			},
			panel = { enabled = false }, -- On utilise Avante pour le chat
		},
	},

	-- Avante : chat IA style Cursor
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
		},
		opts = {
			provider = "copilot",
			-- Les keybinds <leader>aa et <leader>ae sont dans astrocore.lua
		},
	},
}
