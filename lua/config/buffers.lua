-- Buffer helpers: close a buffer by its bufferline ORDINAL (the 1,2,3.. shown in the tabline).
-- Falls back gracefully to the Nth listed buffer if bufferline isn't available yet,
-- so these mappings never error (e.g. before bufferline loads).

local M = {}

--- Return a list of "listed" buffer numbers (the ones that appear as tabs), in order.
local function listed_buffers()
	local bufs = {}
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[b].buflisted and vim.api.nvim_buf_is_loaded(b) then
			table.insert(bufs, b)
		end
	end
	return bufs
end

--- Close the buffer at ordinal position `n` (1-based).
--- Prefers bufferline's own ordinal ordering; falls back to listed-buffer order.
function M.close_ordinal(n)
	-- Preferred: use bufferline's element ordering so it matches the on-screen number.
	local ok, bufferline = pcall(require, "bufferline")
	if ok and bufferline.get_elements then
		local elements = bufferline.get_elements()
		local els = elements and elements.elements or {}
		if els[n] and els[n].id then
			pcall(vim.api.nvim_buf_delete, els[n].id, { force = false })
			return
		else
			vim.notify("No buffer at position " .. n, vim.log.levels.INFO)
			return
		end
	end

	-- Fallback: Nth listed buffer (used only if bufferline isn't loaded).
	local bufs = listed_buffers()
	if bufs[n] then
		pcall(vim.api.nvim_buf_delete, bufs[n], { force = false })
	else
		vim.notify("No buffer at position " .. n, vim.log.levels.INFO)
	end
end

--- Close all buffers except the current one (listed, non-modified handled by :bd).
function M.close_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(listed_buffers()) do
		if b ~= current then
			pcall(vim.api.nvim_buf_delete, b, { force = false })
		end
	end
end

return M
