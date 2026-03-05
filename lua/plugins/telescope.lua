return {
	'nvim-telescope/telescope.nvim', version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local builtin = require('telescope.builtin')
		local sorters = require('telescope.sorters')

		local function make_source_priority_sorter(separator)
			-- separator: "$" pour find_files (fin de ligne), ":" pour live_grep (avant le numéro de ligne)
			return function()
				local base_sorter = sorters.get_fuzzy_file()
				local original_scoring = base_sorter.scoring_function

				base_sorter.scoring_function = function(self, prompt, line, ...)
					local score = original_scoring(self, prompt, line, ...)
					if score <= 0 then return 0 end

					local pat = separator == "$" and "%." or "%.[^:]+:"
					-- Boost .c/.cpp/.cc/.cxx
					if line:match("%.c" .. separator)
						or line:match("%.cpp" .. separator)
						or line:match("%.cc" .. separator)
						or line:match("%.cxx" .. separator) then
						score = score * 0.5
					end
					-- Pénalise .h/.hpp
					if line:match("%.h" .. separator)
						or line:match("%.hpp" .. separator) then
						score = score * 2.0
					end

					return score
				end

				return base_sorter
			end
		end

		require('telescope').setup({
			defaults = {
				file_ignore_patterns = {
					"%.o$",
					"%.obj$",
					"%.a$",
					"%.so$",
					"%.out$",
				},
			},
			pickers = {
				man_pages = {
					sections = { "ALL" },
				},
				find_files = {
					file_sorter = make_source_priority_sorter("$"),
				},
				live_grep = {
					file_sorter = make_source_priority_sorter(":"),
				},
			},
		})

	end
}
