local map = vim.keymap.set
local opts = { silent = true }

vim.g.mapleader = " "

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

-- Lsp
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		map('n', 'gd', vim.lsp.buf.definition, opts)
		map('n', 'gD', vim.lsp.buf.declaration, opts)
		map('n', 'gr', vim.lsp.buf.references, opts)
		map('n', 'K', vim.lsp.buf.hover, opts)
		map('n', '<leader>rn', vim.lsp.buf.rename, opts)
		map("n", "<leader>rN", function()
			vim.lsp.buf.rename()
		end, { desc = "Rename project-wide (best effort)" })
		map('n', '<leader>z', function()
			vim.lsp.buf.code_action({ apply = true })
		end, opts)
		map('n', '[d', vim.diagnostic.goto_prev, opts)
		map('n', ']d', vim.diagnostic.goto_next, opts)
	end,
})

-- neotree
map("n", "<leader>e", "<cmd>Neotree float toggle<cr>", { desc = "Neo-tree (float)" })

-- telescope
map('n', '<leader>f', function()
	require('telescope.builtin').find_files()
end, { desc = 'Telescope find files' })

map('n', '<leader>g', function()
	require('telescope.builtin').live_grep()
end, { desc = 'Telescope live grep' })

map('n', '<leader>m', function()
	require('telescope.builtin').man_pages()
end, { desc = 'Telescope man pages' })

-- Words : naviguer entre les occurrences
map('n', '<C-n>', function() Snacks.words.jump(1) end,  { desc = 'Mot suivant' })
map('n', '<C-p>', function() Snacks.words.jump(-1) end, { desc = 'Mot précédent' })

-- LazyGit
map('n', '<leader>G', function() Snacks.lazygit.open() end,      { desc = 'LazyGit' })

-- Folding ergonomique via leader
map("n", "<leader>m", "zm", { desc = "Fold all" })
map("n", "<leader>r", "zr", { desc = "Unfold all" })
map("n", "<leader>j", "za", { desc = "Toggle fold" })

-- Navigation fenêtres rotative
map("n", "<leader>c", "<C-w>w", { desc = "Next window" })
map("n", "<leader>C", "<C-w>W", { desc = "Prev window" })
map("n", "<C-h>", "<cmd>bprev<cr>", opts)
map("n", "<C-l>", "<cmd>bnext<cr>", opts)

map("v", "<C-q>", "<Esc><cmd>write<cr><cmd>qall<CR>", opts)
map("i", "<C-q>", "<Esc><cmd>write<cr><cmd>qall<CR>", opts)
map("n", "<C-q>", "<Esc><cmd>write<cr><cmd>qall<CR>", opts)
map("v", "<C-s>", "<Esc><cmd>write<CR>", opts)
map("i", "<C-s>", "<Esc><cmd>write<CR>", opts)
map("n", "<C-s>", "<Esc><cmd>write<CR>", opts)
map("i", "jj", "<Esc>", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "kk", "<Esc>", { noremap = true, silent = true })
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
