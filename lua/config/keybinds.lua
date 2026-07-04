local map = vim.keymap.set
local opts = { silent = true }

-- NOTE: mapleader/maplocalleader are set in lua/config/lazy.lua (single source of truth).

-- Quickfix navigation
map('n', '<leader>ln', ':cnext<CR>', { desc = 'Quickfix suivant' })
map('n', '<leader>lp', ':cprev<CR>', { desc = 'Quickfix précédent' })
map('n', '<leader>lq', ':cclose<CR>', { desc = 'Fermer quickfix' })
map('n', '<leader>le', function()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Erreurs projet → quickfix' })

-- ==========================================================================
-- Terminal (snacks — split horizontal en bas)
-- ==========================================================================
local function toggle_term()
	require("snacks").terminal.toggle()
end

-- <C-t> : toggle (ouvre / hide en gardant l'historique) — normal + terminal.
map("n", "<C-t>", toggle_term, { desc = "Toggle terminal", silent = true })
map("t", "<C-t>", toggle_term, { desc = "Toggle terminal", silent = true })

-- <Esc><Esc> : terminal-mode -> normal mode.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal: to normal mode", silent = true })

-- En mode terminal, TOUTES les <C-flèche> cyclent les 4 tailles prédéfinies
-- (très fin -> fin -> moyen -> fullscreen). Pas de resize fin : c'est du toggle.
--   Up / Right = plus grand    |    Down / Left = plus petit
map("t", "<C-Up>",    [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(1)<CR>i]],  { desc = "Terminal: taille +", silent = true })
map("t", "<C-Right>", [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(1)<CR>i]],  { desc = "Terminal: taille +", silent = true })
map("t", "<C-Down>",  [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(-1)<CR>i]], { desc = "Terminal: taille -", silent = true })
map("t", "<C-Left>",  [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(-1)<CR>i]], { desc = "Terminal: taille -", silent = true })

-- Netree float
vim.keymap.set("n", "<leader>e", function()
	require("neo-tree.command").execute({
		source = "filesystem",
		focus = true,
		reveal = true,
		position = "float",
	})
end, { desc = "Neo-tree focus (float)" })

-- Lsp
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		map('n', 'gd', vim.lsp.buf.definition, opts)
		map('n', 'gD', vim.lsp.buf.declaration, opts)
		-- <leader>r : LSP references (remplace l'ancien gr).
		map('n', '<leader>r', vim.lsp.buf.references, { buffer = event.buf, desc = "LSP references" })
		map('n', 'K', vim.lsp.buf.hover, opts)
		map('n', '<leader>bb', vim.lsp.buf.rename, opts)
		map("n", "<leader>bn", function()
			vim.lsp.buf.rename()
		end, { desc = "Rename project-wide (best effort)" })
		map('n', '<leader>z', function()
			vim.lsp.buf.code_action({ apply = true })
		end, opts)
		map('n', '[d', vim.diagnostic.goto_prev, opts)
		map('n', ']d', vim.diagnostic.goto_next, opts)
	end,
})

-- ==========================================================================
-- Telescope (pickers regroupés sous le préfixe <leader>f)
-- ==========================================================================
-- <leader>ff : find files   (déplacé de <leader>f pour éviter le délai de préfixe)
-- <leader>fb : buffers
-- <leader>fr : fichiers récents (oldfiles)
-- <leader>fh : help tags
-- <leader>fd : diagnostics
-- <leader>fk : keymaps
-- <leader>fm : man pages
-- <leader>g  : live grep (inchangé)
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end,   { desc = 'Telescope: find files' })
map('n', '<leader>fb', function() require('telescope.builtin').buffers() end,      { desc = 'Telescope: buffers' })
map('n', '<leader>fr', function() require('telescope.builtin').oldfiles() end,     { desc = 'Telescope: fichiers récents' })
map('n', '<leader>fh', function() require('telescope.builtin').help_tags() end,    { desc = 'Telescope: help tags' })
map('n', '<leader>fd', function() require('telescope.builtin').diagnostics() end,  { desc = 'Telescope: diagnostics' })
map('n', '<leader>fk', function() require('telescope.builtin').keymaps() end,      { desc = 'Telescope: keymaps' })
map('n', '<leader>fm', function() require('telescope.builtin').man_pages() end,    { desc = 'Telescope: man pages' })

map('n', '<leader>g', function() require('telescope.builtin').live_grep() end,     { desc = 'Telescope: live grep' })

-- Clear search highlight (enlève le surlignage de la dernière recherche /).
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })

-- Words : naviguer entre les occurrences
map('n', '<C-n>', function() Snacks.words.jump(1) end,  { desc = 'Mot suivant' })
map('n', '<C-p>', function() Snacks.words.jump(-1) end, { desc = 'Mot précédent' })

-- LazyGit
map('n', '<C-g>', function() Snacks.lazygit.open() end,      { desc = 'LazyGit' })

-- NOTE: Folding (<leader>m / <leader>r / <leader>j) retiré temporairement.
-- <leader>r est désormais LSP references. Le folding sera repris à une étape dédiée.

-- Navigation fenêtres rotative
map("n", "<leader>c", "<C-w>w", { desc = "Next window" })
map("n", "<leader>C", "<C-w>W", { desc = "Prev window" })

-- ==========================================================================
-- [Step 3 / 3b] Save / Quit (buffer-scoped) + Buffer navigation & ordinal close
-- ==========================================================================
local buffers = require("config.buffers")

-- Save
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>silent write<CR>", { desc = "Save file", silent = true })

-- Quit BUFFER (never quits Neovim)
-- <C-q>     : write then close buffer
-- <C-S-q>   : force close buffer (discard changes)
map({ "n", "i", "v" }, "<C-q>", function() buffers.write_and_close() end, { desc = "Write & close buffer", silent = true })
map("n", "<C-S-q>", function() buffers.force_close() end, { desc = "Force close buffer (no save)", silent = true })

-- Buffer navigation
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Close buffer by its bufferline ORDINAL (the number shown in the top tab bar).
-- <C-1>..<C-9> require the kitty keyboard protocol (WezTerm: enable_kitty_keyboard=true).
-- <leader>1..<leader>9 are the always-working fallback. Prompts if the tab is unsaved.
for i = 1, 9 do
	map("n", "<C-" .. i .. ">", function() buffers.close_ordinal(i) end,
		{ desc = "Close buffer " .. i, silent = true })
	map("n", "<leader>" .. i, function() buffers.close_ordinal(i) end,
		{ desc = "Close buffer " .. i, silent = true })
end

-- Close all OTHER buffers.  <C-`> (kitty protocol) + <leader>bo (always works).
map("n", "<C-`>", function() buffers.close_others() end, { desc = "Close other buffers", silent = true })
map("n", "<leader>bo", function() buffers.close_others() end, { desc = "Close other buffers", silent = true })

-- ==========================================================================
-- [Step 4] Windows / splits + resize (fenêtres de CODE)
-- ==========================================================================
-- Create splits (open right/below thanks to splitright/splitbelow in options.lua)
map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split vertical", silent = true })
map("n", "<leader>h", "<cmd>split<CR>",  { desc = "Split horizontal", silent = true })

-- Close the WINDOW (split pane) — buffer stays open elsewhere.
-- This is your "close the split" key. Distinct from <C-q> (close buffer).
map("n", "<leader>w", "<C-w>c", { desc = "Close window (split)", silent = true })

-- Equalize all split sizes
map("n", "<leader>=", "<C-w>=", { desc = "Equalize splits", silent = true })

-- Resize windows (CODE) with Ctrl + Arrow keys — resize fin +/-2.
-- (En mode terminal, <C-flèche> sert au cycle de tailles, voir plus haut.)
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Grow window height", silent = true })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Shrink window height", silent = true })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Shrink window width", silent = true })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Grow window width", silent = true })

-- ==========================================================================

-- Escape ergonomique (insert)
map("i", "jj", "<Esc>", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "kk", "<Esc>", { noremap = true, silent = true })

-- Paste + reindent logique
local function paste_reindent(before)
  return function()
    if before then
      vim.cmd("normal! P")
    else
      vim.cmd("normal! p")
    end
    -- reindent la zone collée via marks `[` et `]`
    vim.cmd("normal! `[=']")
  end
end
map("n", "p", paste_reindent(false), { desc = "Paste + reindent" })
map("n", "P", paste_reindent(true), { desc = "Paste before + reindent" })
