return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',          -- nouvelle branche (API vim.treesitter native)
	build = ':TSUpdate',
	config = function()
		-- Sur la branche `main`, nvim-treesitter sert à installer/maj les parsers.
		require("nvim-treesitter").setup()

		-- Installe les parsers voulus s'ils manquent (API branche `main`).
		local ensure = { "lua", "c", "cpp", "vim", "vimdoc", "python", "cmake", "markdown", "markdown_inline" }
		pcall(function()
			require("nvim-treesitter").install(ensure)
		end)

		-- Le highlight est natif dans Neovim 0.11+. On l'active par filetype.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "c", "cpp", "vim", "python", "cmake", "markdown" },
			callback = function()
				pcall(vim.treesitter.start)
				-- Indentation basée sur Treesitter (utile en C/C++).
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
