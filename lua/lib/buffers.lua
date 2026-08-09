-- ============================================================
-- lib/buffers.lua — Logique custom de gestion des buffers
-- Porté depuis lua/config/buffers.lua (ancienne config LazyVim)
-- ============================================================
-- Ferme un buffer par son ordinal bufferline (1,2,3...), ferme les autres,
-- write-and-close, force-close. Ne génère jamais d'erreur et prompt avant
-- de supprimer des changements non sauvegardés.
-- Si le DERNIER buffer fichier est fermé, Neovim quitte proprement.

local M = {}

--- Buffers listés (vrais fichiers) dans l'ordre stable.
local function listed_buffers()
	local bufs = {}
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b)
			and vim.bo[b].buflisted
			and vim.bo[b].buftype == ""
		then
			table.insert(bufs, b)
		end
	end
	return bufs
end

--- Vrai si `buf` est le seul buffer fichier restant.
local function is_last_file_buffer(buf)
	local files = listed_buffers()
	return #files <= 1 and (files[1] == buf or #files == 0)
end
M.is_last_file_buffer = is_last_file_buffer

--- Quitte Neovim. Les terminaux sont tués par les autocmds VimLeavePre/QuitPre.
local function quit_nvim(force)
	if force then
		pcall(vim.cmd, "quitall!")
	else
		pcall(vim.cmd, "confirm quitall")
	end
end

--- Ordre bufferline visible (les numéros affichés en haut). nil si indisponible.
local function bufferline_ids()
	local ok, bl = pcall(require, "bufferline")
	if not ok or type(bl.get_elements) ~= "function" then return nil end
	local ok2, result = pcall(bl.get_elements)
	if not ok2 or type(result) ~= "table" then return nil end
	local elements = result.elements or result
	if type(elements) ~= "table" or #elements == 0 then return nil end
	local ids = {}
	for _, el in ipairs(elements) do
		if el and el.id then table.insert(ids, el.id) end
	end
	if #ids == 0 then return nil end
	return ids
end

local function ordered_ids()
	return bufferline_ids() or listed_buffers()
end
M._ordered_ids = ordered_ids

--- Supprime un buffer avec prompt si des changements ne sont pas sauvegardés.
--- Si c'est le dernier buffer fichier, quitte Neovim.
local function delete_buf_prompt(buf)
	if not vim.api.nvim_buf_is_valid(buf) then return end

	local last = is_last_file_buffer(buf)

	if vim.bo[buf].modified then
		local name = vim.api.nvim_buf_get_name(buf)
		name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[Sans nom]"
		local choice = vim.fn.confirm(
			('Sauvegarder "%s" avant de fermer ?'):format(name),
			"&Sauvegarder\n&Ignorer\n&Annuler", 1
		)
		if choice == 1 then
			if vim.api.nvim_buf_get_name(buf) ~= "" then
				vim.api.nvim_buf_call(buf, function() pcall(vim.cmd, "silent write") end)
				if last then quit_nvim(false) return end
				pcall(vim.api.nvim_buf_delete, buf, { force = false })
			else
				vim.notify("Buffer sans nom ; utilise :w <nom> d'abord.", vim.log.levels.WARN)
			end
		elseif choice == 2 then
			if last then quit_nvim(true) return end
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	else
		if last then quit_nvim(false) return end
		pcall(vim.api.nvim_buf_delete, buf, { force = false })
	end
end

--- Ferme l'onglet à l'ordinal `n` (base 1). Prompt si non sauvegardé.
--- Quitte Neovim si c'était le dernier buffer fichier.
function M.close_ordinal(n)
	local ids = ordered_ids()
	local target = ids[n]
	if not target then
		vim.notify(("Pas de buffer à la position %d (seulement %d ouverts)"):format(n, #ids),
			vim.log.levels.INFO)
		return
	end
	delete_buf_prompt(target)
end

--- Ferme tous les buffers listés sauf le courant (prompt par buffer non sauvegardé).
function M.close_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(listed_buffers()) do
		if b ~= current then
			if vim.bo[b].modified then
				local name = vim.api.nvim_buf_get_name(b)
				name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[Sans nom]"
				local choice = vim.fn.confirm(
					('Sauvegarder "%s" avant de fermer ?'):format(name),
					"&Sauvegarder\n&Ignorer\n&Annuler", 1
				)
				if choice == 1 then
					if vim.api.nvim_buf_get_name(b) ~= "" then
						vim.api.nvim_buf_call(b, function() pcall(vim.cmd, "silent write") end)
						pcall(vim.api.nvim_buf_delete, b, { force = false })
					else
						vim.notify("Buffer sans nom ; utilise :w <nom> d'abord.", vim.log.levels.WARN)
					end
				elseif choice == 2 then
					pcall(vim.api.nvim_buf_delete, b, { force = true })
				end
			else
				pcall(vim.api.nvim_buf_delete, b, { force = false })
			end
		end
	end
end

--- Sauvegarde (si fichier réel) puis ferme le buffer courant.
--- Quitte Neovim si c'était le dernier buffer fichier.
function M.write_and_close()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype == "" and vim.bo[buf].modifiable
		and vim.api.nvim_buf_get_name(buf) ~= ""
	then
		local ok, err = pcall(vim.cmd, "silent write")
		if not ok then
			vim.notify("Écriture échouée : " .. tostring(err), vim.log.levels.ERROR)
			return
		end
	end
	if is_last_file_buffer(buf) then
		quit_nvim(false)
		return
	end
	pcall(vim.cmd, "bdelete")
end

--- Ferme de force le buffer courant en ignorant les changements.
--- Quitte Neovim si c'était le dernier buffer fichier.
function M.force_close()
	local buf = vim.api.nvim_get_current_buf()
	if is_last_file_buffer(buf) then
		quit_nvim(true)
		return
	end
	pcall(vim.cmd, "bdelete!")
end

-- ==========================================================================
-- Taille du terminal float (cycle très fin -> fin -> moyen -> fullscreen)
-- ==========================================================================
-- Pour un terminal float (snacks), on resize la floating window elle-même.
-- Les valeurs sont des fractions de l'écran (height = fraction, width fixe à 0.8).
local FLOAT_HEIGHTS = { 0.25, 0.4, 0.6, 0.85 }
local float_level = 2  -- niveau par défaut (0.4)

--- Cycle la taille du float terminal. direction = 1 (plus grand) ou -1 (plus petit).
function M.cycle_term_size(direction)
	local new_level = float_level + direction
	if new_level < 1 then new_level = 1 end
	if new_level > #FLOAT_HEIGHTS then new_level = #FLOAT_HEIGHTS end
	float_level = new_level

	-- Tente de modifier la fenêtre float courante (snacks terminal).
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)
	if cfg.relative ~= "" then  -- c'est bien une floating window
		local new_h = math.floor(vim.o.lines * FLOAT_HEIGHTS[float_level])
		cfg.height = new_h
		pcall(vim.api.nvim_win_set_config, win, cfg)
	end
end

--- Ré-applique la taille mémorisée à la fenêtre terminal courante.
--- Appelé par un autocmd quand une fenêtre terminal est entrée/ouverte.
function M.apply_saved_term_size()
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)
	if cfg.relative ~= "" then
		local new_h = math.floor(vim.o.lines * FLOAT_HEIGHTS[float_level])
		cfg.height = new_h
		pcall(vim.api.nvim_win_set_config, win, cfg)
	end
end

-- Commande debug : montre ce que l'ordinal resolver voit.
vim.api.nvim_create_user_command("BufOrdinals", function()
	local ids = ordered_ids()
	local src = bufferline_ids() and "bufferline" or "listed_buffers (fallback)"
	local lines = { "Source ordinaux : " .. src, "Nombre : " .. #ids }
	for i, id in ipairs(ids) do
		local name = vim.api.nvim_buf_get_name(id)
		name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[Sans nom]"
		table.insert(lines, ("  %d -> buf %d  %s"):format(i, id, name))
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Affiche les ordinaux des buffers (tels que vus par les touches de fermeture)" })

return M
