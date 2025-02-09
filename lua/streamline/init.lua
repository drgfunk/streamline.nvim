-- luacheck: globals vim

local M = {}
local uv = vim.loop

-- Default configuration
M.defaults = {
	sections = {
		left = {
			"mode",
			"git_branch",
			"filename",
		},
		middle = {},
		right = {
			"indent",
			"filetype",
		},
	},
	excluded_filetypes = {
		"TelescopePrompt",
		"snacks_picker_input",
	},
}

M.options = {}

-- Main setup function
function M.setup(opts)
	require("streamline.highlights").setup()

	M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

	-- Initial render
	M.render()
end

local async_render
async_render = uv.new_async(vim.schedule_wrap(function()
	M.render()
end))

function M.load_streamline()
	async_render:send()
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

M.render = vim.schedule_wrap(function()
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

	vim.opt.statusline = table.concat(sections, "")
end)

function M.streamline_augroup()
	-- Set up autocommand for updates
	vim.api.nvim_create_autocmd({
		"ColorScheme",
		"ModeChanged",
		"WinEnter",
		"BufEnter",
		"WinLeave",
		"BufLeave",
		"BufReadPost",
		"BufWritePost",
	}, {
		pattern = "*",
		callback = function()
			M.load_streamline()
		end,
	})
end

return M
