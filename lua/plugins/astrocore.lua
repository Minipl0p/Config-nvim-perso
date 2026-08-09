-- ============================================================
-- astrocore.lua — Options globales et keybinds (AstroNvim v4)
-- ============================================================
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- --------------------------------------------------------
		-- Options Vim
		-- --------------------------------------------------------
		options = {
			opt = {
				number          = true,
				relativenumber  = true,
				cursorline      = true,
				wrap            = false,
				scrolloff       = 10,
				sidescrolloff   = 5,
				-- Indentation (tabs, pas d'espaces)
				tabstop         = 4,
				shiftwidth      = 4,
				softtabstop     = 0,
				expandtab       = false,
				smartindent     = true,
				autoindent      = true,
				-- Affichage des caractères invisibles
				list            = true,
				listchars       = "tab:▸ ,trail:·,extends:…,precedes:…",
				-- Recherche
				ignorecase      = true,
				smartcase       = true,
				-- Splits
				splitright      = true,
				splitbelow      = true,
				-- Comportement général
				confirm         = true,
				mouse           = "a",
				clipboard       = "unnamedplus",
				undofile        = true,
				updatetime      = 300,
				timeoutlen      = 500,
				-- Visuel
				conceallevel    = 2,   -- IMPORTANT pour render-markdown
				signcolumn      = "yes",
				showmode        = false,
				pumheight       = 10,
				pumblend        = 10,
				-- Divers (shortmess géré nativement par AstroNvim)
				fillchars       = "eob: ",
			},
		},

		-- --------------------------------------------------------
		-- Keybinds
		-- --------------------------------------------------------
		mappings = {
			-- ---- Mode normal ----
			n = {
				-- Désactiver les splits natifs AstroNvim sur <C-h/j/k/l>
				-- (on les réutilise pour autre chose ci-dessous)
				["<C-h>"] = false,
				["<C-j>"] = false,
				["<C-k>"] = false,
				["<C-l>"] = false,

				-- Navigation buffers
				["<C-h>"] = { "<cmd>bprevious<CR>", desc = "Buffer précédent" },
				["<C-l>"] = { "<cmd>bnext<CR>",     desc = "Buffer suivant" },

				-- Mouvements rapides (10 lignes)
				["<C-j>"] = { "10j", desc = "10 lignes bas" },
				["<C-k>"] = { "10k", desc = "10 lignes haut" },

				-- H/L → sauter les mots (remplace b/w)
				["H"] = { "b", desc = "Mot précédent" },
				["L"] = { "w", desc = "Mot suivant" },

				-- Telescope (<leader>f remplace le format d'AstroNvim)
				["<leader>f"] = {
					function() require("telescope.builtin").find_files() end,
					desc = "Telescope : trouver des fichiers",
				},
				["<leader>g"] = {
					function() require("telescope.builtin").live_grep() end,
					desc = "Telescope : recherche textuelle",
				},
				["<leader>d"] = {
					function() require("telescope.builtin").diagnostics() end,
					desc = "Telescope : diagnostics",
				},
				["<leader>M"] = {
					function() require("telescope.builtin").man_pages() end,
					desc = "Telescope : pages man",
				},

				-- Save / Quit
				["<C-s>"] = { "<Esc><cmd>silent write<CR>", desc = "Sauvegarder" },
				["<C-q>"] = {
					function() require("lib.buffers").write_and_close() end,
					desc = "Sauvegarder et fermer le buffer",
				},
				["<C-S-q>"] = {
					function() require("lib.buffers").force_close() end,
					desc = "Fermer de force le buffer (sans sauvegarder)",
				},

				-- Fermer buffer par ordinal <leader>1..<leader>9
				["<leader>1"] = { function() require("lib.buffers").close_ordinal(1) end, desc = "Fermer buffer 1" },
				["<leader>2"] = { function() require("lib.buffers").close_ordinal(2) end, desc = "Fermer buffer 2" },
				["<leader>3"] = { function() require("lib.buffers").close_ordinal(3) end, desc = "Fermer buffer 3" },
				["<leader>4"] = { function() require("lib.buffers").close_ordinal(4) end, desc = "Fermer buffer 4" },
				["<leader>5"] = { function() require("lib.buffers").close_ordinal(5) end, desc = "Fermer buffer 5" },
				["<leader>6"] = { function() require("lib.buffers").close_ordinal(6) end, desc = "Fermer buffer 6" },
				["<leader>7"] = { function() require("lib.buffers").close_ordinal(7) end, desc = "Fermer buffer 7" },
				["<leader>8"] = { function() require("lib.buffers").close_ordinal(8) end, desc = "Fermer buffer 8" },
				["<leader>9"] = { function() require("lib.buffers").close_ordinal(9) end, desc = "Fermer buffer 9" },

				-- Fermer buffer par ordinal <C-1>..<C-9> (Kitty/WezTerm keyboard protocol)
				["<C-1>"] = { function() require("lib.buffers").close_ordinal(1) end, desc = "Fermer buffer 1" },
				["<C-2>"] = { function() require("lib.buffers").close_ordinal(2) end, desc = "Fermer buffer 2" },
				["<C-3>"] = { function() require("lib.buffers").close_ordinal(3) end, desc = "Fermer buffer 3" },
				["<C-4>"] = { function() require("lib.buffers").close_ordinal(4) end, desc = "Fermer buffer 4" },
				["<C-5>"] = { function() require("lib.buffers").close_ordinal(5) end, desc = "Fermer buffer 5" },
				["<C-6>"] = { function() require("lib.buffers").close_ordinal(6) end, desc = "Fermer buffer 6" },
				["<C-7>"] = { function() require("lib.buffers").close_ordinal(7) end, desc = "Fermer buffer 7" },
				["<C-8>"] = { function() require("lib.buffers").close_ordinal(8) end, desc = "Fermer buffer 8" },
				["<C-9>"] = { function() require("lib.buffers").close_ordinal(9) end, desc = "Fermer buffer 9" },

				-- Fermer autres buffers (<C-`> requiert le protocole clavier kitty)
				["<C-`>"] = {
					function() require("lib.buffers").close_others() end,
					desc = "Fermer les autres buffers",
				},

				-- Terminal toggle
				["<C-t>"] = {
					function() require("snacks").terminal.toggle() end,
					desc = "Toggle terminal float",
				},

				-- LazyGit
				["<C-g>"] = {
					function() require("snacks").lazygit.open() end,
					desc = "LazyGit",
				},

				-- Neo-tree float
				["<leader>e"] = {
					function()
						require("neo-tree.command").execute({
							source = "filesystem",
							focus = true,
							reveal = true,
							position = "float",
						})
					end,
					desc = "Neo-tree (float)",
				},

				-- Splits
				["<leader>v"] = { "<cmd>vsplit<CR>",  desc = "Split vertical" },
				["<leader>h"] = { "<cmd>split<CR>",   desc = "Split horizontal" },
				["<leader>w"] = { "<C-w>c",           desc = "Fermer la fenêtre (split)" },
				["<leader>="] = { "<C-w>=",            desc = "Équilibrer les splits" },

				-- Redimensionner les splits (mode normal uniquement)
				["<C-Up>"]    = { "<cmd>resize +2<CR>",          desc = "Agrandir hauteur fenêtre" },
				["<C-Down>"]  = { "<cmd>resize -2<CR>",          desc = "Réduire hauteur fenêtre" },
				["<C-Left>"]  = { "<cmd>vertical resize -2<CR>", desc = "Réduire largeur fenêtre" },
				["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Agrandir largeur fenêtre" },

				-- Navigation fenêtres rotative
				["<leader>c"] = { "<C-w>w", desc = "Fenêtre suivante" },
				["<leader>C"] = { "<C-w>W", desc = "Fenêtre précédente" },

				-- Quickfix
				["<leader>ln"] = { "<cmd>cnext<CR>",  desc = "Quickfix suivant" },
				["<leader>lp"] = { "<cmd>cprev<CR>",  desc = "Quickfix précédent" },
				["<leader>lq"] = { "<cmd>cclose<CR>", desc = "Fermer quickfix" },
				["<leader>le"] = {
					function()
						vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
					end,
					desc = "Erreurs projet → quickfix",
				},

				-- Rename dans le fichier (sans LSP)
				["<leader>n"] = {
					function()
						local w = vim.fn.expand("<cword>")
						if w == "" then return end
						local keys = ":%s/\\<" .. w .. "\\>//gI" .. string.rep("<Left>", 3)
						local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
						vim.api.nvim_feedkeys(termcodes, "n", false)
					end,
					desc = "Renommer dans le fichier (curseur prêt)",
				},

				-- Commentaire (natif Neovim 0.10+)
				["<C-/>"] = { "gcc", desc = "Commenter la ligne", remap = true },
				["<C-_>"] = { "gcc", desc = "Commenter la ligne", remap = true },

				-- Join sans déplacer le curseur
				["J"] = { "mzJ`z", desc = "Joindre (curseur fixe)" },

				-- Clear search highlight
				["<Esc>"] = { "<cmd>nohlsearch<CR>", desc = "Effacer le surlignage de recherche" },

				-- Git
				["<leader>gd"] = { "<cmd>DiffviewOpen<CR>",        desc = "Diffview : ouvrir" },
				["<leader>gh"] = { "<cmd>DiffviewFileHistory<CR>",  desc = "Diffview : historique fichier" },
				["<leader>gx"] = { "<cmd>DiffviewClose<CR>",        desc = "Diffview : fermer" },

				-- DAP
				["<F5>"]       = { function() require("dap").continue() end,          desc = "DAP : continuer" },
				["<F10>"]      = { function() require("dap").step_over() end,         desc = "DAP : step over" },
				["<F11>"]      = { function() require("dap").step_into() end,         desc = "DAP : step into" },
				["<F12>"]      = { function() require("dap").step_out() end,          desc = "DAP : step out" },
				["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "DAP : breakpoint" },
				["<leader>du"] = { function() require("dapui").toggle() end,          desc = "DAP : toggle UI" },
				["<leader>dr"] = { function() require("dap").repl.open() end,         desc = "DAP : REPL" },

				-- Markdown preview
				["<leader>mp"] = { "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown : preview toggle" },

				-- AI — Avante
				["<leader>aa"] = { "<cmd>AvanteAsk<CR>", desc = "Avante : demander" },

				-- LSP rename sémantique
				["<leader>b"] = {
					function()
						vim.ui.input({ prompt = "Nouveau nom : " }, function(new_name)
							if new_name and new_name ~= "" then
								vim.lsp.buf.rename(new_name)
							end
						end)
					end,
					desc = "Renommer (LSP, projet entier)",
				},

				-- Code action
				["<leader>z"] = {
					function() vim.lsp.buf.code_action({ apply = true }) end,
					desc = "Code action (LSP)",
				},

				-- Navigation diagnostics
				["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Diagnostic précédent" },
				["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Diagnostic suivant" },
			},

			-- ---- Mode insertion ----
			i = {
				-- Escape ergonomique
				["jj"] = { "<Esc>", desc = "Échapper (ergonomique)" },
				["jk"] = { "<Esc>", desc = "Échapper (ergonomique)" },
				["kk"] = { "<Esc>", desc = "Échapper (ergonomique)" },
				-- Save depuis insert
				["<C-s>"] = { "<Esc><cmd>silent write<CR>", desc = "Sauvegarder" },
				-- Quit depuis insert
				["<C-q>"] = {
					function() require("lib.buffers").write_and_close() end,
					desc = "Sauvegarder et fermer le buffer",
				},
			},

			-- ---- Mode visuel ----
			v = {
				-- Mouvements rapides
				["<C-j>"] = { "10j", desc = "10 lignes bas" },
				["<C-k>"] = { "10k", desc = "10 lignes haut" },
				-- H/L → mots
				["H"] = { "b", desc = "Mot précédent" },
				["L"] = { "w", desc = "Mot suivant" },
				-- Save depuis visuel
				["<C-s>"] = { "<Esc><cmd>silent write<CR>", desc = "Sauvegarder" },
				-- Quit depuis visuel
				["<C-q>"] = {
					function() require("lib.buffers").write_and_close() end,
					desc = "Sauvegarder et fermer le buffer",
				},
				-- Commenter la sélection
				["<C-/>"] = { "gc", desc = "Commenter la sélection", remap = true },
				["<C-_>"] = { "gc", desc = "Commenter la sélection", remap = true },
				-- Indentation garde la sélection
				["<"] = { "<gv", desc = "Désindenter (garde la sélection)" },
				[">"] = { ">gv", desc = "Indenter (garde la sélection)" },
				-- Remplacer dans la sélection
				["<leader>n"] = {
					function()
						local keys = ":s//g" .. string.rep("<Left>", 2)
						local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
						vim.api.nvim_feedkeys(termcodes, "n", false)
					end,
					desc = "Remplacer dans la sélection",
				},
				-- AI — Avante (édition sur sélection)
				["<leader>ae"] = { "<cmd>AvanteEdit<CR>", desc = "Avante : éditer la sélection" },
			},

			-- ---- Mode terminal ----
			t = {
				-- Toggle terminal depuis le terminal
				["<C-t>"] = {
					function() require("snacks").terminal.toggle() end,
					desc = "Toggle terminal",
				},
				-- Retour en mode normal depuis le terminal
				["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Terminal : mode normal" },
				-- Cycle taille du float terminal
				["<C-Up>"] = {
					"<C-\\><C-n><cmd>lua require('lib.buffers').cycle_term_size(1)<CR>i",
					desc = "Terminal : agrandir",
				},
				["<C-Right>"] = {
					"<C-\\><C-n><cmd>lua require('lib.buffers').cycle_term_size(1)<CR>i",
					desc = "Terminal : agrandir",
				},
				["<C-Down>"] = {
					"<C-\\><C-n><cmd>lua require('lib.buffers').cycle_term_size(-1)<CR>i",
					desc = "Terminal : réduire",
				},
				["<C-Left>"] = {
					"<C-\\><C-n><cmd>lua require('lib.buffers').cycle_term_size(-1)<CR>i",
					desc = "Terminal : réduire",
				},
			},
		},

		-- --------------------------------------------------------
		-- Autocmds (portés depuis l'ancienne config)
		-- --------------------------------------------------------
		autocmds = {
			-- Tuer tous les terminaux quand Neovim quitte
			terminal_lifecycle = {
				{
					event = { "VimLeavePre", "QuitPre" },
					desc = "Tuer les terminaux à la fermeture",
					callback = function()
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
								pcall(vim.api.nvim_buf_delete, buf, { force = true })
							end
						end
					end,
				},
				{
					event = { "TermOpen", "WinEnter" },
					desc = "Restaurer la taille du terminal float",
					callback = function()
						if vim.bo.buftype == "terminal" then
							vim.schedule(function()
								pcall(function() require("lib.buffers").apply_saved_term_size() end)
							end)
						end
					end,
				},
			},
			-- `nvim <dossier>` → ouvrir Neo-tree en float
			startup_neotree = {
				{
					event = "VimEnter",
					desc = "Ouvrir Neo-tree si lancé sur un dossier",
					callback = function()
						local argv = vim.fn.argv()
						if #argv ~= 1 then return end
						local path = argv[1]
						if vim.fn.isdirectory(path) ~= 1 then return end
						vim.schedule(function()
							local dir_bufs = {}
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_buf_is_valid(buf) then
									local name = vim.api.nvim_buf_get_name(buf)
									if name ~= "" and vim.fn.isdirectory(name) == 1 then
										table.insert(dir_bufs, buf)
									end
								end
							end
							pcall(vim.cmd, "enew")
							for _, buf in ipairs(dir_bufs) do
								if vim.api.nvim_buf_is_valid(buf) then
									pcall(vim.api.nvim_buf_delete, buf, { force = true })
								end
							end
							pcall(function()
								require("neo-tree.command").execute({
									source = "filesystem",
									focus = true,
									position = "float",
									dir = path,
								})
							end)
						end)
					end,
				},
			},
			-- Surlignage du yank
			yank_highlight = {
				{
					event = "TextYankPost",
					desc = "Surligner le texte copié",
					callback = function()
						vim.hl.on_yank({ higroup = "IncSearch", timeout = 130 })
					end,
				},
			},
		},
	},
}
