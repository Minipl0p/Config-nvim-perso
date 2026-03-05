return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"pyright",
				"lua_ls",
			},
		})

		vim.lsp.config.clangd = {
			cmd = { "clangd" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = { "compile_commands.json", ".clangd", "Makefile", ".git" },
		}

		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = { "pyrightconfig.json", "setup.py", "requirements.txt", ".git" },
		}

		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".git" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		}

		vim.lsp.enable({ "clangd", "pyright", "lua_ls" })

		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.diagnostic.open_float({
					border = "rounded",
					source = true,
					scope = "line",
					focusable = false,
				})
			end,
		})

		vim.o.updatetime = 300

	end
}
