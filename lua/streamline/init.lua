local M = {}

-- Default configuration
M.defaults = {
	-- Add your default options here
	theme = "default",
	icons = true,
	sections = {
		left = {
			"mode",
			"git_branch",
			"filename",
		},
		middle = {},
		right = {
			"filetype",
		},
	},
	excluded_filetypes = {
		"TelescopePrompt",
		"snacks_picker_input",
	},
}

-- Store the user's configuration
M.options = {}

-- Main setup function
function M.setup(opts)
	require("streamline.highlights").setup()

	M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

	-- Set up autocommand for updates
	vim.api.nvim_create_autocmd({ "ModeChanged", "WinEnter", "BufEnter", "WinLeave", "BufLeave" }, {
		pattern = "*",
		callback = function()
			M.render()
		end,
	})

	-- Initial render
	vim.opt.statusline = "%!v:lua.require'streamline'.render()"
end

local function process_section(components)
	local result = {}

	if components == nil then
		return ""
	end

	for _, component in ipairs(components) do
		if type(component) == "string" then
			local ok, comp = pcall(require, "streamline.components")
			if ok and comp[component] then
				table.insert(result, comp[component]())
			end
		elseif type(component) == "function" then
			table.insert(result, component())
		end
	end
	return table.concat(result, " ")
end

function M.render()
	local expander = "%="
	local ft = vim.bo.filetype

	-- hide statusline if filetype is in excluded_filetypes
	if vim.tbl_contains(M.options.excluded_filetypes, ft) then
		return ""
	end

	local sections = {
		process_section(M.options.sections.left),
		expander,
		process_section(M.options.sections.middle),
		expander,
		process_section(M.options.sections.right),
	}

	return table.concat(sections, "")
end

return M
