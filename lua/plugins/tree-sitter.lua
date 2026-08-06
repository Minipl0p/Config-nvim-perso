return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	build = ':TSUpdate',
	config = function()
		require("nvim-treesitter").setup()

		-- Ajoute html, css, javascript, typescript pour Transcendance
		local ensure = {
			"lua", "c", "cpp", "vim", "vimdoc", "python", "cmake",
			"markdown", "markdown_inline",
			"html", "css", "javascript", "typescript", -- ← AJOUT
		}
		pcall(function()
			require("nvim-treesitter").install(ensure)
		end)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"lua", "c", "cpp", "vim", "python", "cmake", "markdown",
				"html", "css", "javascript", "typescript", -- ← AJOUT
			},
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
