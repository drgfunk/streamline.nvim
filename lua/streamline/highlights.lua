local M = {}

function M.setup()
	-- Define your highlight groups here
	vim.api.nvim_set_hl(0, "StreamlineMode", { fg = "#ff0000", bg = "#000000" })
	vim.api.nvim_set_hl(0, "StreamlineGitBranch", { fg = "#ff0000", bg = "#000000" })
	vim.api.nvim_set_hl(0, "StreamlineFilename", { fg = "#ff0000", bg = "#000000" })
	vim.api.nvim_set_hl(0, "StreamlineModified", { fg = "#ff0000", bg = "#000000" })
	vim.api.nvim_set_hl(0, "StreamlineFiletype", { fg = "#ff0000", bg = "#000000" })

	-- import rose-pine colors and if found, use them
	local rose_pine = require("rose-pine.palette")
	if rose_pine then
		vim.api.nvim_set_hl(0, "StreamlineMode", { fg = rose_pine.base, bg = rose_pine.text })
		vim.api.nvim_set_hl(0, "StreamlineGitBranch", { fg = rose_pine.text, bg = rose_pine.overlay })
		vim.api.nvim_set_hl(0, "StreamlineFilename", { fg = rose_pine.muted, bg = rose_pine.transparent })
		vim.api.nvim_set_hl(0, "StreamlineModified", { fg = rose_pine.gold, bg = rose_pine.transparent })
		vim.api.nvim_set_hl(0, "StreamlineFiletype", { fg = rose_pine.base, bg = rose_pine.text })
		vim.api.nvim_set_hl(0, "StreamlineIndent", { fg = rose_pine.muted, bg = rose_pine.transparent })
	end
end

return M
