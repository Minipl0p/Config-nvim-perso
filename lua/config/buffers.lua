-- Buffer helpers: close a buffer by its bufferline ORDINAL (the 1,2,3.. shown in the
-- top tab bar), close others, write-and-close, force-close.
-- Never errors, and prompts before discarding unsaved changes.

local M = {}

--- Listed, real file buffers in stable order (fallback if bufferline isn't ready).
local function listed_buffers()
	local bufs = {}
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b)
			and vim.bo[b].buflisted
			and vim.bo[b].buftype == ""
		then
			table.insert(bufs, b)
		end
	end
	return bufs
end

--- Bufferline's visible ordering (so the number matches the tab). nil if unusable.
local function bufferline_ids()
	local ok, bl = pcall(require, "bufferline")
	if not ok or type(bl.get_elements) ~= "function" then return nil end
	local ok2, result = pcall(bl.get_elements)
	if not ok2 or type(result) ~= "table" then return nil end
	local elements = result.elements or result
	if type(elements) ~= "table" or #elements == 0 then return nil end
	local ids = {}
	for _, el in ipairs(elements) do
		if el and el.id then table.insert(ids, el.id) end
	end
	if #ids == 0 then return nil end
	return ids
end

local function ordered_ids()
	return bufferline_ids() or listed_buffers()
end
M._ordered_ids = ordered_ids

--- Delete a buffer, prompting if it has unsaved changes.
local function delete_buf_prompt(buf)
	if not vim.api.nvim_buf_is_valid(buf) then return end
	if vim.bo[buf].modified then
		local name = vim.api.nvim_buf_get_name(buf)
		name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
		local choice = vim.fn.confirm(
			("Save changes to \"%s\" before closing?"):format(name),
			"&Save\n&Discard\n&Cancel", 1
		)
		if choice == 1 then          -- Save
			if vim.api.nvim_buf_get_name(buf) ~= "" then
				vim.api.nvim_buf_call(buf, function() pcall(vim.cmd, "silent write") end)
				pcall(vim.api.nvim_buf_delete, buf, { force = false })
			else
				vim.notify("Buffer has no name; use :w <name> first.", vim.log.levels.WARN)
			end
		elseif choice == 2 then      -- Discard
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
		-- choice == 3 (Cancel) or 0 (Esc): do nothing
	else
		pcall(vim.api.nvim_buf_delete, buf, { force = false })
	end
end

--- Close the tab at ordinal position `n` (1-based). Prompts if unsaved.
function M.close_ordinal(n)
	local ids = ordered_ids()
	local target = ids[n]
	if not target then
		vim.notify(("No buffer at position %d (only %d open)"):format(n, #ids), vim.log.levels.INFO)
		return
	end
	delete_buf_prompt(target)
end

--- Close all listed buffers except the current one (prompts per unsaved).
function M.close_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(listed_buffers()) do
		if b ~= current then
			delete_buf_prompt(b)
		end
	end
end

--- Write (if real file) then close current buffer. Never quits Neovim.
function M.write_and_close()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype == "" and vim.bo[buf].modifiable and vim.api.nvim_buf_get_name(buf) ~= "" then
		local ok, err = pcall(vim.cmd, "silent write")
		if not ok then
			vim.notify("Write failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end
	end
	pcall(vim.cmd, "bdelete")
end

--- Force close current buffer, discarding changes. Never quits Neovim.
function M.force_close()
	pcall(vim.cmd, "bdelete!")
end

-- Debug: show what the ordinal resolver sees.
vim.api.nvim_create_user_command("BufOrdinals", function()
	local ids = ordered_ids()
	local src = bufferline_ids() and "bufferline" or "listed_buffers (fallback)"
	local lines = { "Ordinal source: " .. src, "Count: " .. #ids }
	for i, id in ipairs(ids) do
		local name = vim.api.nvim_buf_get_name(id)
		name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
		table.insert(lines, ("  %d -> buf %d  %s"):format(i, id, name))
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show buffer ordinals as the close-by-number keys see them" })

return M
