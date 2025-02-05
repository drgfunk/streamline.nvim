local M = {}

-- Default configuration
M.defaults = {
	-- Add your default options here
	theme = "default",
	icons = true,
	sections = {
		left = {},
		middle = {},
		right = {},
	},
}

-- Store the user's configuration
M.options = {}

-- Main setup function
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
	-- Initialize your statusline here
end

function M.render()
	local result = {}

	-- Process left section components
	for _, component in ipairs(M.options.sections.left) do
		if type(component) == "function" then
			table.insert(result, component())
		end
	end

	-- Similar for middle and right sections
	-- Then join everything together
	vim.opt.statusline = table.concat(result, " ")
end

return M
