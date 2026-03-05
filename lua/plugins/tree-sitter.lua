return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	config = function()
		-- nvim-treesitter sert maintenant juste à installer les parsers
		require("nvim-treesitter").setup({
			ensure_installed = {
				"lua",
				"c",
				"cpp",
				"vim",
				"python",
				"cmake",
			},
			auto_install = false,
		})

		-- Le highlight est maintenant natif dans Neovim 0.11+
		-- On l'active manuellement via un autocmd
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "c", "cpp", "vim", "python", "cmake" },
			callback = function()
				pcall(vim.treesitter.start)
				vim.opt.foldmethod = "expr"
				vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.opt.foldenable = true
				vim.opt.foldlevelstart = 99
				vim.opt.foldlevel = 99
				vim.opt.foldnestmax = 1
				vim.opt.foldtext = "getline(v:foldstart) . ' ... ' . (v:foldend - v:foldstart + 1) . ' lines'"
			end,
		})

	end
}
