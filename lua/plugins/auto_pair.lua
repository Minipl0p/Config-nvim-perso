return {
	'windwp/nvim-autopairs',
	event = "InsertEnter",
	opts = {
	},
	{
	"numToStr/Comment.nvim",
	keys = {
		{ "gc", mode = { "n", "v" }, desc = "Toggle comment" },
		{ "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
	},
	opts = {},
},

	-- use opts = {} for passing setup options
	-- this is equivalent to setup({}) function
}
