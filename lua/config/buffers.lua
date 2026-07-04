-- Buffer helpers: navigation-independent utilities for closing buffers by ordinal
-- and closing "other" buffers. Designed to never error, even before bufferline loads.

local M = {}

--- Return listed, real buffers in a stable order (these are what appear as tabs).
--- Excludes unlisted/special buffers (neo-tree, terminals, help, etc.).
local function listed_buffers()
	local bufs = {}
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b)
			and vim.bo[b].buflisted
			and vim.bo[b].buftype == ""  -- normal file buffers only
		then
			table.insert(bufs, b)
		end
	end
	return bufs
end

--- Try bufferline's visible ordering first (so numbers match the tabline).
--- Returns a list of buffer ids, or nil if bufferline isn't usable yet.
local function bufferline_ids()
	local ok, bufferline = pcall(require, "bufferline")
	if not ok or type(bufferline.get_elements) ~= "function" then
		return nil
	end
	local ok2, result = pcall(bufferline.get_elements)
	if not ok2 or type(result) ~= "table" then
		return nil
	end
	local elements = result.elements or result
	if type(elements) ~= "table" or #elements == 0 then
		return nil
	end
	local ids = {}
	for _, el in ipairs(elements) do
		if el and el.id then
			table.insert(ids, el.id)
		end
	end
	if #ids == 0 then
		return nil
	end
	return ids
end

--- Resolve the ordered list of buffer ids (bufferline first, else listed buffers).
local function ordered_ids()
	return bufferline_ids() or listed_buffers()
end

--- Close the buffer at ordinal position `n` (1-based), matching the tabline number.
function M.close_ordinal(n)
	local ids = ordered_ids()
	local target = ids[n]
	if not target then
		vim.notify("No buffer at position " .. n, vim.log.levels.INFO)
		return
	end
	-- Use bdelete via pcall; force=false so unsaved changes are protected.
	pcall(vim.api.nvim_buf_delete, target, { force = false })
end

--- Close all listed buffers except the current one.
function M.close_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(listed_buffers()) do
		if b ~= current then
			pcall(vim.api.nvim_buf_delete, b, { force = false })
		end
	end
end

--- Write current buffer (if it's a real, modifiable file) then close it.
--- Never quits Neovim; leaves other buffers/windows intact.
function M.write_and_close()
	local buf = vim.api.nvim_get_current_buf()
	local bt = vim.bo[buf].buftype
	local name = vim.api.nvim_buf_get_name(buf)
	-- Only :write if it's a normal, named, modifiable file buffer.
	if bt == "" and vim.bo[buf].modifiable and name ~= "" then
		local ok, err = pcall(vim.cmd, "silent write")
		if not ok then
			vim.notify("Write failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end
	end
	pcall(vim.cmd, "bdelete")
end

--- Force close current buffer, discarding unsaved changes. Never quits Neovim.
function M.force_close()
	pcall(vim.cmd, "bdelete!")
end

return M
