-- ============================================================
-- dap.lua — Debug Adapter Protocol (nvim-dap + dap-ui)
-- ============================================================
return {
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap    = require("dap")
			local dapui  = require("dapui")

			-- Auto-ouvre et ferme l'UI sur les événements DAP
			dap.listeners.before.attach.dapui_config    = function() dapui.open() end
			dap.listeners.before.launch.dapui_config    = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end

			-- Texte virtuel sur les variables
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- DAP UI
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		opts = {
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			layouts = {
				{
					elements = {
						{ id = "scopes",      size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks",      size = 0.25 },
						{ id = "watches",     size = 0.25 },
					},
					size    = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl",    size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size    = 10,
					position = "bottom",
				},
			},
		},
	},

	-- Mason-nvim-dap : installe les adaptateurs automatiquement
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = { "codelldb", "python" },
			automatic_installation = true,
			handlers = {},
		},
	},

	-- Texte virtuel DAP
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			commented = true,
		},
	},
}
