return {
	"stevearc/conform.nvim",
	dependencies = {
		{ "mason-org/mason.nvim" },
		{ "zapling/mason-conform.nvim" }, -- ← installe auto les formatters manquants
	},
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			c          = { "clang_format" },
			cpp        = { "clang_format" },
			html       = { "prettier" },
			css        = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			python     = { "black" },
		},
		formatters = {
			clang_format = {
				prepend_args = { "--style=file:" .. vim.fn.expand("~/.clang-format") },
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
