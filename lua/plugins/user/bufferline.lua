-- ============================================================
-- bufferline.lua — Override bufferline (AstroNvim v4)
-- ============================================================
return {
	"akinsho/bufferline.nvim",
	opts = {
		options = {
			mode             = "buffers",
			numbers          = "ordinal",
			diagnostics      = "nvim_lsp",
			separator_style  = "slant",
			show_buffer_close_icons = false,
			show_close_icon  = false,
			always_show_bufferline = true,
			hover = {
				enabled = true,
				delay   = 200,
				reveal  = { "close" },
			},
			indicator = {
				style = "underline",
			},
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or " "
				return " " .. count .. icon
			end,
			-- Masque les buffers terminaux de la bufferline
			-- pour ne pas décaler les ordinaux <C-1>..<C-9>
			custom_filter = function(buf_number)
				if vim.bo[buf_number].buftype == "terminal" then
					return false
				end
				return true
			end,
		},
	},
}
