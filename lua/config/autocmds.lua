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
