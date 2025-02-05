local M = {}

function M.setup()
	-- Define your highlight groups here
	vim.api.nvim_set_hl(0, "StreamlineNormal", { fg = "#ffffff", bg = "#000000" })
end

return M
