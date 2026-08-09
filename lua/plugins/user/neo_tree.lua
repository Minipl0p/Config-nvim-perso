-- ============================================================
-- neo_tree.lua — Override Neo-tree float (AstroNvim v4)
-- ============================================================
return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		popup_border_style  = "rounded",
		enable_git_status   = true,
		enable_diagnostics  = true,
		window = {
			position = "float",
			width    = 40,
			mappings = {
				-- l = ouvrir (aller à droite)
				["l"]    = "open",
				["<CR>"] = "open",
				["<S-CR>"] = "open",

				-- <C-CR> = ouvre puis ferme les autres buffers
				["<C-CR>"] = function(state)
					local node = state.tree:get_node()
					if node.type == "file" then
						require("neo-tree.sources.filesystem.commands").open(state)
						vim.schedule(function()
							require("lib.buffers").close_others()
						end)
					else
						require("neo-tree.sources.filesystem.commands").open(state)
					end
				end,

				-- h = replier / remonter au parent
				["h"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" and node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					else
						local parent_id = node:get_parent_id()
						if parent_id then
							local parent = state.tree:get_node(parent_id)
							require("neo-tree.ui.renderer").focus_node(state, parent_id)
							if parent and parent.type == "directory" and parent:is_expanded() then
								require("neo-tree.sources.filesystem").toggle_directory(state, parent)
							end
						end
					end
				end,

				-- Désactive H/L dans neo-tree pour ne pas masquer la nav buffers
				["H"] = false,
				["L"] = false,
			},
		},
		filesystem = {
			-- Ne hijack pas netrw (nvim . ouvre le float, géré par l'autocmd VimEnter)
			hijack_netrw_behavior = "disabled",
			filtered_items = {
				visible       = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
		default_component_configs = {
			indent = { with_expanders = true },
		},
	},
}
