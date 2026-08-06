return {
	"zapling/mason-conform.nvim",
	dependencies = { "mason-org/mason.nvim", "stevearc/conform.nvim" },
	config = function()
		require("mason-conform").setup({
			ignore_install = { "clang_format" }, -- clang-format s'installe via le système, pas Mason
		})
	end,
}
