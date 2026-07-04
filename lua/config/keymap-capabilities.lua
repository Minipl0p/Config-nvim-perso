-- Detects whether Ctrl+digit keys (like <C-1>) reach Neovim as DISTINCT keys.
-- The kitty keyboard protocol enables this (WezTerm needs enable_kitty_keyboard=true).
--
-- NOTE: there is NO reliable API field for this (kitty_keyboard does NOT exist on
-- nvim_list_uis()). The only source of truth is an empirical check + a diagnostic
-- command. Later steps ALWAYS bind a <leader>N fallback so nothing depends on this.

local M = {}

-- We optimistically assume distinct Ctrl-digits are available, because binding
-- <C-1>..<C-9> is harmless when they aren't (they simply never fire, and the
-- <leader>1..9 fallback covers that case).
M.assume_ctrl_digits = true

-- :CheckKittyKeys — sets a temporary <C-1> map so you can verify by pressing it.
vim.api.nvim_create_user_command("CheckKittyKeys", function()
	vim.keymap.set("n", "<C-1>", function()
		vim.notify("Ctrl+1 is DISTINCT — <C-1>..<C-9> mappings will work.", vim.log.levels.INFO)
	end, { desc = "Probe: press Ctrl+1 to confirm distinct Ctrl-digit keys" })
	vim.notify(
		"Now press Ctrl+1 in normal mode.\n"
		.. "  - If you see 'Ctrl+1 is DISTINCT' -> it works.\n"
		.. "  - If nothing happens / it starts a count -> not distinct;\n"
		.. "    use the <leader>1..9 fallback (WezTerm needs enable_kitty_keyboard=true).",
		vim.log.levels.INFO
	)
end, { desc = "Probe kitty Ctrl-digit support (press Ctrl+1 after running)" })

return M
