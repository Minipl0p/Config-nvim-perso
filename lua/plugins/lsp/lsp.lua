return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- fournit les capabilities de complétion
	},
	config = function()
		-- Réduit le bruit du log LSP (ton lsp.log montait à ~187 Mo).
		-- API à jour (Nvim 0.11+) : vim.lsp.log.set_level.
		-- Vider l'ancien fichier une fois : :lua vim.fn.delete(vim.lsp.get_log_path())
		vim.lsp.log.set_level(vim.log.levels.ERROR)

		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"pyright",
				"lua_ls",
			},
		})

		-- Capabilities étendues (nvim-cmp) : complétion LSP plus riche
		-- (documentation, snippets, détails). Fusionnées avec les defaults.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		if ok_cmp then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
		end

		vim.lsp.config.clangd = {
			cmd = {
				"clangd",
				"--background-index",   -- indexe le projet en arrière-plan (nav plus rapide)
				"--clang-tidy",         -- conseils qualité de code en plus
				-- NB: pas de --header-insertion=never : on garde l'insertion auto d'includes.
			},
			capabilities = capabilities,
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = { "compile_commands.json", ".clangd", "Makefile", ".git" },
		}

		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			capabilities = capabilities,
			filetypes = { "python" },
			root_markers = { "pyrightconfig.json", "setup.py", "requirements.txt", ".git" },
		}

		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			capabilities = capabilities,
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

		-- Diagnostic flottant au survol : normal (CursorHold) ET insert (CursorHoldI),
		-- pour l'avoir dès que le curseur se pose/reste sur une ligne en erreur.
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				vim.diagnostic.open_float({
					border = "rounded",
					source = true,
					scope = "line",
					focusable = false,
				})
			end,
		})

		-- ============================================================
		-- :CompileDB — génère compile_commands.json pour clangd.
		-- Essaie compiledb, puis bear, sinon explique quoi faire.
		-- ============================================================
		vim.api.nvim_create_user_command("CompileDB", function()
			local function has(exe) return vim.fn.executable(exe) == 1 end

			local cmd
			if has("compiledb") then
				cmd = { "compiledb", "make" }
			elseif has("bear") then
				cmd = { "bear", "--", "make" }
			else
				vim.notify(
					"Ni 'compiledb' ni 'bear' trouvés.\n" ..
					"-> pip install --user compiledb  (sans sudo)\n" ..
					"-> ou crée un fichier .clangd à la racine (voir README).",
					vim.log.levels.WARN
				)
				return
			end

			vim.notify("CompileDB: " .. table.concat(cmd, " ") .. " ...", vim.log.levels.INFO)
			vim.system(cmd, { text = true }, function(res)
				vim.schedule(function()
					if res.code == 0 then
						vim.notify("compile_commands.json généré ✔ — clangd rechargé.", vim.log.levels.INFO)
						pcall(vim.cmd, "LspRestart clangd")
					else
						vim.notify("CompileDB a échoué:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
					end
				end)
			end)
		end, { desc = "Génère compile_commands.json (compiledb/bear) et recharge clangd" })
	end
}
