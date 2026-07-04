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

--term : toggle
vim.keymap.set('t', '<C-t>', function()
	vim.cmd('q') -- ferme le terminal flottant
end, { desc = 'Fermer terminal snacks en mode terminal' })

vim.keymap.set('n', '<C-t>', function()
	require('snacks').terminal.toggle()
end, { desc = 'Toggle terminal snacks en mode normal' })

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
		map('n', 'gr', vim.lsp.buf.references, opts)
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

-- telescope
map('n', '<leader>f', function()
	require('telescope.builtin').find_files()
end, { desc = 'Telescope find files' })

map('n', '<leader>g', function()
	require('telescope.builtin').live_grep()
end, { desc = 'Telescope live grep' })

map('n', '<leader>h', function()
	require('telescope.builtin').man_pages()
end, { desc = 'Telescope man pages' })

-- Words : naviguer entre les occurrences
map('n', '<C-n>', function() Snacks.words.jump(1) end,  { desc = 'Mot suivant' })
map('n', '<C-p>', function() Snacks.words.jump(-1) end, { desc = 'Mot précédent' })

-- LazyGit
map('n', '<C-g>', function() Snacks.lazygit.open() end,      { desc = 'LazyGit' })

-- Folding ergonomique via leader
map("n", "<leader>m", "zm", { desc = "Fold all" })
map("n", "<leader>r", "zr", { desc = "Unfold all" })
map("n", "<leader>j", "za", { desc = "Toggle fold" })

-- Navigation fenêtres rotative
map("n", "<leader>c", "<C-w>w", { desc = "Next window" })
map("n", "<leader>C", "<C-w>W", { desc = "Prev window" })

-- ==========================================================================
-- [Step 3] Save / Quit (buffer-scoped) + Buffer navigation & ordinal close
-- ==========================================================================
local buffers = require("config.buffers")

-- Save
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>write<CR>", { desc = "Save file", silent = true })

-- Quit BUFFER (never quits Neovim)
map({ "n", "i", "v" }, "<C-q>", "<Esc><cmd>write<CR><cmd>bdelete<CR>",  { desc = "Write & close buffer", silent = true })
map({ "n", "i", "v" }, "<C-Q>", "<Esc><cmd>bdelete!<CR>",               { desc = "Force close buffer",   silent = true })

-- Buffer navigation
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Close buffer by ordinal (matches the number shown in bufferline once Step 7 lands).
-- <C-1>..<C-9> require the kitty keyboard protocol (WezTerm: enable_kitty_keyboard=true).
-- <leader>1..<leader>9 are the always-working fallback.
for i = 1, 9 do
	map("n", "<C-" .. i .. ">", function() buffers.close_ordinal(i) end,
		{ desc = "Close buffer " .. i, silent = true })
	map("n", "<leader>" .. i, function() buffers.close_ordinal(i) end,
		{ desc = "Close buffer " .. i, silent = true })
end

-- Close all other buffers
map("n", "<leader>bo", function() buffers.close_others() end, { desc = "Close other buffers", silent = true })

-- ==========================================================================

-- Escape ergonomique (insert)
map("i", "jj", "<Esc>", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "kk", "<Esc>", { noremap = true, silent = true })

-- Vertical split (horizontal split arrives in Step 4)
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })

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
