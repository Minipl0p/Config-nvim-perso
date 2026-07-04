return {
	'nvim-telescope/telescope.nvim', version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local sorters = require('telescope.sorters')

		local function make_source_priority_sorter(separator)
			-- separator: "$" pour find_files (fin de ligne), ":" pour live_grep (avant le numéro de ligne)
			return function()
				local base_sorter = sorters.get_fuzzy_file()
				local original_scoring = base_sorter.scoring_function

				base_sorter.scoring_function = function(self, prompt, line, ...)
					local score = original_scoring(self, prompt, line, ...)
					if score <= 0 then return 0 end

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

		telescope.setup({
			defaults = {
				-- Layout lisible : liste à gauche, preview à droite.
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = { preview_width = 0.55 },
					width = 0.9,
					height = 0.9,
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				file_ignore_patterns = {
					"%.o$",
					"%.obj$",
					"%.a$",
					"%.so$",
					"%.out$",
					"^%.git/",
					"/%.git/",
					"node_modules/",
					"%.class$",
					"%.pyc$",
				},
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<Esc>"] = actions.close,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				man_pages = {
					sections = { "ALL" },
				},
				find_files = {
					file_sorter = make_source_priority_sorter("$"),
					hidden = true,
				},
				live_grep = {
					file_sorter = make_source_priority_sorter(":"),
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
	end
}
