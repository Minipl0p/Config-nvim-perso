-- ==========================================================================
-- Autocommands
-- ==========================================================================

--- Ferme de force tous les buffers terminaux (arrête les process shell).
local function kill_all_terminals()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end

local grp = vim.api.nvim_create_augroup("MyTerminalLifecycle", { clear = true })

-- Quand on QUITTE Neovim (:q, :wq, :qa...), tuer les terminaux d'abord pour ne pas
-- laisser un split terminal ouvert / empêcher la fermeture.
vim.api.nvim_create_autocmd({ "VimLeavePre", "QuitPre" }, {
	group = grp,
	callback = function()
		kill_all_terminals()
	end,
})

-- Réapplique la taille mémorisée du terminal quand on entre dans une fenêtre terminal
-- (au toggle on : la taille précédente est restaurée au lieu du défaut).
vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
	group = grp,
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.schedule(function()
				pcall(function() require("config.buffers").apply_saved_term_size() end)
			end)
		end
	end,
})

-- ==========================================================================
-- Démarrage : `nvim <dossier>` -> ouvrir Neo-tree en FLOAT (jamais de sidebar,
-- jamais de buffer/onglet "dossier" résiduel).
-- ==========================================================================
local start_grp = vim.api.nvim_create_augroup("MyStartupNeoTree", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = start_grp,
	callback = function()
		-- On ne traite que le cas : un seul argument, et c'est un dossier.
		local argv = vim.fn.argv()
		if #argv ~= 1 then
			return
		end
		local path = argv[1]
		if vim.fn.isdirectory(path) ~= 1 then
			return
		end

		vim.schedule(function()
			-- 1) Repère le(s) buffer(s) "dossier" AVANT de toucher à quoi que ce soit.
			--    (un buffer dont le nom résolu est un répertoire)
			local dir_bufs = {}
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) then
					local name = vim.api.nvim_buf_get_name(buf)
					if name ~= "" and vim.fn.isdirectory(name) == 1 then
						table.insert(dir_bufs, buf)
					end
				end
			end

			-- 2) Crée un buffer vide propre et bascule dessus (fenêtre courante).
			pcall(vim.cmd, "enew")

			-- 3) Supprime explicitement chaque buffer "dossier" repéré.
			--    -> plus aucun onglet "nvim/" dans la bufferline.
			for _, buf in ipairs(dir_bufs) do
				if vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end

			-- 4) Ouvre Neo-tree en float sur le dossier passé en argument.
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
})
