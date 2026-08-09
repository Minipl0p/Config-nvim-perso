return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "BufEnter" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "flake8" },
		}

		-- Lance le linter automatiquement
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
