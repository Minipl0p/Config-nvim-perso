-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Toggle comment (ligne)
map("n", "<C-\\>", "gcc", { remap = true, silent = true })
-- Toggle comment (visuel)
map("v", "<C-\\>", "gc", { remap = true, silent = true })
