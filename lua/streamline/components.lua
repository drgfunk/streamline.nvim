-- luacheck: globals vim
local M = {}

function M.mode()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = require("streamline.utils").get_mode_name(mode)

	return table.concat({ "%#StreamlineMode#", " ", string.upper(mode_name), " " })
end

function M.git_branch()
	local branch = require("streamline.utils").get_branch_name(20)
	return table.concat({ "%#StreamlineGitBranch#", "  ", branch, " " })
end

function M.filename()
	local result = {}
	local current_buf = vim.api.nvim_get_current_buf()
	local current_name = vim.fn.bufname(current_buf)

	if current_name == "" then
		return "[No Name]"
	end

	local base_name = vim.fn.fnamemodify(current_name, ":t")

	-- Check other buffers for same filename
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.fn.buflisted(buf) == 1 then
			local buf_name = vim.fn.bufname(buf)
			local other_base = vim.fn.fnamemodify(buf_name, ":t")

			if base_name == other_base then
				-- Add parent directory
				base_name = vim.fn.fnamemodify(current_name, ":h:t") .. "/" .. base_name
			end
		end
	end

	table.insert(result, "%#StreamlineFilename#")
	table.insert(result, "  ")
	table.insert(result, base_name)

	if vim.bo.modified then
		table.insert(result, "%#StreamlineModified# 󰧞")
	end

	table.insert(result, "  ")

	return table.concat(result)
end

function M.filetype()
	local icon = require("streamline.utils").get_filetype_icon()
	local ft = vim.bo.filetype

	return table.concat({ "%#StreamlineFiletype#", icon, " %#StreamlineFiletype#", ft, " " })
end

function M.indent()
	local indent = vim.bo.expandtab and "󱁐 Spaces" or "󰌒 Tabs"
	return table.concat({ "%#StreamlineIndent#  ", indent, "  " })
end

return M
