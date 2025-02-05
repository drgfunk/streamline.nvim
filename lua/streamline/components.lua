local M = {}

function M.mode()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = require("streamline.utils").get_mode_name(mode)
	return "%#StreamlineMode#" .. " " .. string.upper(mode_name) .. " "
end

function M.git_branch()
	local branch = require("streamline.utils").get_branch_name(20)
	return "%#StreamlineGitBranch#" .. "  " .. branch .. " "
end

function M.filename()
	local file = vim.fn.expand("%:t")
	if vim.bo.modified then
		file = file .. "%#StreamlineModified# 󰧞"
	end
	return "%#StreamlineFilename#" .. "  " .. file .. "  "
end

function M.filetype()
	local icon = require("streamline.utils").get_filetype_icon()
	local ft = vim.bo.filetype

	return "%#StreamlineFiletype#" .. icon .. " %#StreamlineFiletype#" .. ft .. " "
end

return M
