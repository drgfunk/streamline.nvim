local M = {}

-- Example component function
function M.mode()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = require("streamline.utils").get_mode_name(mode)
	return mode_name
end

return M
