-- Buffer helpers: close a buffer by its bufferline ORDINAL (the 1,2,3.. shown in the
-- top tab bar), close others, write-and-close, force-close.
-- Never errors, and prompts before discarding unsaved changes.
-- If closing the LAST real file buffer, quit Neovim instead of leaving a [No Name].

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

--- True if `buf` is the only remaining real file buffer.
--- Terminals and unlisted/special buffers are ignored on purpose.
local function is_last_file_buffer(buf)
	local files = listed_buffers()
	return #files <= 1 and (files[1] == buf or #files == 0)
end
M.is_last_file_buffer = is_last_file_buffer

--- Quit Neovim. Terminals are killed by the VimLeavePre/QuitPre autocmds.
local function quit_nvim(force)
	if force then
		pcall(vim.cmd, "quitall!")
	else
		-- :confirm quitall prompts for any other unsaved (safety net).
		pcall(vim.cmd, "confirm quitall")
	end
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
--- If it's the last file buffer, quit Neovim instead of leaving a [No Name].
local function delete_buf_prompt(buf)
	if not vim.api.nvim_buf_is_valid(buf) then return end

	local last = is_last_file_buffer(buf)

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
				if last then quit_nvim(false) return end
				pcall(vim.api.nvim_buf_delete, buf, { force = false })
			else
				vim.notify("Buffer has no name; use :w <name> first.", vim.log.levels.WARN)
			end
		elseif choice == 2 then      -- Discard
			if last then quit_nvim(true) return end
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
		-- choice == 3 (Cancel) or 0 (Esc): do nothing
	else
		if last then quit_nvim(false) return end
		pcall(vim.api.nvim_buf_delete, buf, { force = false })
	end
end

--- Close the tab at ordinal position `n` (1-based). Prompts if unsaved.
--- Quits Neovim if it was the last file buffer.
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
			-- Never quit here: we keep the current buffer, so use plain delete.
			if vim.bo[b].modified then
				local name = vim.api.nvim_buf_get_name(b)
				name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
				local choice = vim.fn.confirm(
					("Save changes to \"%s\" before closing?"):format(name),
					"&Save\n&Discard\n&Cancel", 1
				)
				if choice == 1 then
					if vim.api.nvim_buf_get_name(b) ~= "" then
						vim.api.nvim_buf_call(b, function() pcall(vim.cmd, "silent write") end)
						pcall(vim.api.nvim_buf_delete, b, { force = false })
					else
						vim.notify("Buffer has no name; use :w <name> first.", vim.log.levels.WARN)
					end
				elseif choice == 2 then
					pcall(vim.api.nvim_buf_delete, b, { force = true })
				end
			else
				pcall(vim.api.nvim_buf_delete, b, { force = false })
			end
		end
	end
end

--- Write (if real file) then close current buffer.
--- Quits Neovim if it was the last file buffer (instead of leaving [No Name]).
function M.write_and_close()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype == "" and vim.bo[buf].modifiable and vim.api.nvim_buf_get_name(buf) ~= "" then
		local ok, err = pcall(vim.cmd, "silent write")
		if not ok then
			vim.notify("Write failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end
	end
	if is_last_file_buffer(buf) then
		quit_nvim(false)
		return
	end
	pcall(vim.cmd, "bdelete")
end

--- Force close current buffer, discarding changes.
--- Quits Neovim if it was the last file buffer.
function M.force_close()
	local buf = vim.api.nvim_get_current_buf()
	if is_last_file_buffer(buf) then
		quit_nvim(true)
		return
	end
	pcall(vim.cmd, "bdelete!")
end

-- ==========================================================================
-- Terminal size cycle (very thin -> thin -> medium -> fullscreen)
-- + remembers the last size so toggling off/on keeps it.
-- ==========================================================================
-- Heights: absolute line counts for the small ones, fractions for the big ones.
--   1 = très fin (8 lines), 2 = fin (15 lines), 3 = moyen (~50%), 4 = fullscreen (~95%)
local TERM_LEVELS = { 8, 15, 0.5, 0.95 }
local term_level = 2  -- default starting level (matches the ~0.3 you had, roughly "fin")

--- Resolve a level value to an absolute number of lines for :resize.
local function level_to_lines(v)
	if v <= 1 then
		-- fraction of total editor height
		return math.max(3, math.floor(vim.o.lines * v))
	end
	return v
end

--- Apply the current level's height to the current window.
local function apply_term_level()
	local lines = level_to_lines(TERM_LEVELS[term_level])
	pcall(vim.cmd, "resize " .. lines)
end

--- Cycle terminal size. direction = 1 (bigger) or -1 (smaller). Bounded (no wrap).
function M.cycle_term_size(direction)
	local new_level = term_level + direction
	if new_level < 1 then new_level = 1 end
	if new_level > #TERM_LEVELS then new_level = #TERM_LEVELS end
	term_level = new_level
	apply_term_level()
end

--- Re-apply the remembered size to the current (terminal) window.
--- Called by an autocmd when a terminal window is entered/opened (toggle on).
function M.apply_saved_term_size()
	apply_term_level()
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
