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
map("t", "<C-Up>", [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(1)<CR>i]],
	{ desc = "Terminal: taille +", silent = true })
map("t", "<C-Right>", [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(1)<CR>i]],
	{ desc = "Terminal: taille +", silent = true })
map("t", "<C-Down>", [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(-1)<CR>i]],
	{ desc = "Terminal: taille -", silent = true })
map("t", "<C-Left>", [[<C-\><C-n><cmd>lua require("config.buffers").cycle_term_size(-1)<CR>i]],
	{ desc = "Terminal: taille -", silent = true })

-- Netree float
vim.keymap.set("n", "<leader>e", function()
	require("neo-tree.command").execute({
		source = "filesystem",
		focus = true,
		reveal = true,
		position = "float",
	})
end, { desc = "Neo-tree focus (float)" })

-- ==========================================================================
-- LSP (buffer-local, une fois le serveur attaché)
-- ==========================================================================
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local bopts = { buffer = event.buf }
		map('n', 'gd', vim.lsp.buf.definition, bopts) -- définition
		map('n', 'gD', vim.lsp.buf.declaration, bopts) -- déclaration
		map('n', 'gr', vim.lsp.buf.references, bopts) -- références
		map('n', 'K', vim.lsp.buf.hover, bopts)

		-- <leader>b : rename SÉMANTIQUE projet entier (LSP).
		-- Invite VIDE -> le curseur est prêt à taper le NOUVEAU nom.
		map('n', '<leader>b', function()
			vim.ui.input({ prompt = "Nouveau nom : " }, function(new_name)
				if new_name and new_name ~= "" then
					vim.lsp.buf.rename(new_name)
				end
			end)
		end, { buffer = event.buf, desc = "Rename projet (LSP)" })

		-- Code action (applique automatiquement).
		map('n', '<leader>z', function()
			vim.lsp.buf.code_action({ apply = true })
		end, bopts)

		-- Navigation diagnostics.
		map('n', '[d', vim.diagnostic.goto_prev, bopts)
		map('n', ']d', vim.diagnostic.goto_next, bopts)
	end,
})

-- <leader>n : rename dans le FICHIER (texte, marche même sans LSP).
-- Curseur placé PRÊT à écrire le remplacement (entre les deux / du milieu).
vim.keymap.set('n', '<leader>n', function()
	local w = vim.fn.expand('<cword>')
	if w == '' then return end
	-- :%s/\<mot\>//gI  puis 3x <Left> pour placer le curseur entre les //
	local keys = ':%s/\\<' .. w .. '\\>//gI' .. string.rep('<Left>', 3)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, 'n', false)
end, { desc = "Rename dans le fichier (curseur prêt)" })

-- ==========================================================================
-- Déplacements rapides <C-hjkl> (normal + visuel)
--   <C-j> : 10 lignes bas      <C-k> : 10 lignes haut
--   <C-l> : mot suivant (w)    <C-h> : mot précédent (b)
-- NB: <C-flèches> restent le resize des splits / la taille du terminal.
-- ==========================================================================
map({ "n", "x" }, "<C-j>", "10j", { desc = "10 lignes bas", silent = true })
map({ "n", "x" }, "<C-k>", "10k", { desc = "10 lignes haut", silent = true })
map({ "n", "x" }, "<C-l>", "w", { desc = "Mot suivant", silent = true })
map({ "n", "x" }, "<C-h>", "b", { desc = "Mot précédent", silent = true })

-- ==========================================================================
-- Telescope (binds simples, pas de combo à 3 touches)
-- ==========================================================================
-- <leader>f : find files
-- <leader>g : live grep
-- <leader>d : diagnostics
-- <leader>M : man pages
map('n', '<leader>f', function() require('telescope.builtin').find_files() end, { desc = 'Telescope: find files' })
map('n', '<leader>g', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope: live grep' })
map('n', '<leader>d', function() require('telescope.builtin').diagnostics() end, { desc = 'Telescope: diagnostics' })
map('n', '<leader>M', function() require('telescope.builtin').man_pages() end, { desc = 'Telescope: man pages' })

-- Clear search highlight (enlève le surlignage de la dernière recherche /).
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight', silent = true })


-- LazyGit
map('n', '<C-g>', function() Snacks.lazygit.open() end, { desc = 'LazyGit' })

-- NOTE: Folding (<leader>m / <leader>j) et <leader>r sont libres.
-- Le folding sera repris à une étape dédiée (choix de nouveaux binds).

-- Navigation fenêtres rotative
map("n", "<leader>c", "<C-w>w", { desc = "Next window" })
map("n", "<leader>C", "<C-w>W", { desc = "Prev window" })

-- ==========================================================================
-- [Step 3 / 3b] Save / Quit (buffer-scoped) + Buffer navigation & ordinal close
-- ==========================================================================
local buffers = require("config.buffers")

-- Save
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>silent write<CR>", { desc = "Save file", silent = true })

-- Quit BUFFER (si dernier fichier -> quitte Neovim, voir buffers.lua)
-- <C-q>     : write then close buffer
-- <C-S-q>   : force close buffer (discard changes)
map({ "n", "i", "v" }, "<C-q>", function() buffers.write_and_close() end,
	{ desc = "Write & close buffer", silent = true })
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

-- Close all OTHER buffers.  <C-`> (kitty protocol).
map("n", "<C-`>", function() buffers.close_others() end, { desc = "Close other buffers", silent = true })

-- ==========================================================================
-- [Step 4] Windows / splits + resize (fenêtres de CODE)
-- ==========================================================================
-- Create splits (open right/below thanks to splitright/splitbelow in options.lua)
map("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split vertical", silent = true })
map("n", "<leader>h", "<cmd>split<CR>", { desc = "Split horizontal", silent = true })

-- Close the WINDOW (split pane) — buffer stays open elsewhere.
-- This is your "close the split" key. Distinct from <C-q> (close buffer).
map("n", "<leader>w", "<C-w>c", { desc = "Close window (split)", silent = true })

-- Equalize all split sizes
map("n", "<leader>=", "<C-w>=", { desc = "Equalize splits", silent = true })

-- Resize windows (CODE) with Ctrl + Arrow keys — resize fin +/-2.
-- (En mode terminal, <C-flèche> sert au cycle de tailles, voir plus haut.)
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Grow window height", silent = true })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shrink window height", silent = true })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Shrink window width", silent = true })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Grow window width", silent = true })

-- ==========================================================================

-- Escape ergonomique (insert)
map("i", "jj", "<Esc>", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "kk", "<Esc>", { noremap = true, silent = true })

-- ==========================================================================
-- [Step 12] Édition : Comment, Join, Indent visuel
-- ==========================================================================

-- Comment (natif Neovim 0.10+). <C-/> et <C-_> (selon terminal) pour commenter.
--   Normal : commente la ligne courante.
--   Visuel : commente la sélection.
map("n", "<C-/>", "gcc", { remap = true, desc = "Commenter la ligne" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Commenter la ligne" })
map("x", "<C-/>", "gc", { remap = true, desc = "Commenter la sélection" })
map("x", "<C-_>", "gc", { remap = true, desc = "Commenter la sélection" })

-- Join : joint la ligne suivante SANS déplacer le curseur.
map("n", "J", "mzJ`z", { desc = "Join (curseur fixe)", silent = true })

-- Indent en visuel : garde la sélection pour enchaîner les indentations.
map("x", "<", "<gv", { desc = "Désindenter (garde sélection)", silent = true })
map("x", ">", ">gv", { desc = "Indenter (garde sélection)", silent = true })

-- <leader>n en mode VISUEL : pré-écrit une substitution sur la sélection.
-- Résultat dans la ligne de commande :  :'<,'>s//g
-- avec le curseur placé entre les deux premiers / (prêt à taper le motif).
-- Le préfixe '<,'> est ajouté automatiquement par Neovim car on est en visuel.
vim.keymap.set("x", "<leader>n", function()
	local keys = ":s//g" .. string.rep("<Left>", 2)
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "n", false)
end, { desc = "Remplacer dans la sélection (curseur prêt)" })
