-- luacheck: globals vim
local M = {}

function M.get_mode_name(mode)
	local mode_names = {
		["n"] = "Normal",
		["no"] = "N·Operator Pending",
		["nov"] = "N·Operator Pending·Character-wise",
		["noV"] = "N·Operator Pending·Line-wise",
		["no\22"] = "N·Operator Pending·Block-wise",
		["niI"] = "N·Insert·Insert",
		["niR"] = "N·Insert·Replace",
		["niV"] = "N·Insert·Virtual Replace",
		["nt"] = "N·Terminal",
		["v"] = "Visual",
		["vs"] = "V·Select",
		["V"] = "V Line",
		["Vs"] = "V Line·Select",
		["\22"] = "V Block",
		["\22s"] = "V Block·Select",
		["s"] = "Select",
		["S"] = "Select Line",
		["\19"] = "Select Block",
		["i"] = "Insert",
		["ic"] = "Insert·Completion",
		["ix"] = "Insert·Completion·ctrl-x",
		["R"] = "Replace",
		["Rc"] = "Replace·Completion",
		["Rx"] = "Replace·Completion·ctrl-x",
		["Rv"] = "Virtual Replace",
		["Rvc"] = "Virtual Replace·Completion",
		["Rvx"] = "Virtual Replace·Completion·ctrl-x",
		["c"] = "Search",
		["cv"] = "Vim Ex",
		["ce"] = "Ex",
		["r"] = "Prompt",
		["rm"] = "More",
		["r?"] = "Confirm",
		["!"] = "Shell",
		["t"] = "Terminal",
	}

	return mode_names[mode] or "Unknown"
end

function M.get_branch_name(max_length)
	max_length = max_length or 20

	local handle = io.popen("git branch --show-current 2>/dev/null")
	if handle == nil then
		return ""
	end

	local branch = handle:read("*a")
	handle:close()

	if branch and branch ~= "" then
		branch = branch:gsub("^%s*(.-)%s*$", "%1")
		if #branch > max_length then
			return branch:sub(1, max_length - 3) .. "..."
		end
		return branch
	end
	return ""
end

local function add_background_to_highlight(group_name, bg_color)
	local existing_hl = vim.api.nvim_get_hl_by_name(group_name, true) -- Get existing highlight

	if existing_hl then -- Check if the highlight group exists
		local new_hl = vim.deepcopy(existing_hl) -- Create a copy to avoid modifying the original
		new_hl.bg = bg_color -- Set the background color

		vim.api.nvim_set_hl(0, "StreamlineFiletypeIcon", new_hl) -- Update the highlight
	else
		print("Highlight group '" .. group_name .. "' not found.")
	end
end

local function get_icon_provider()
	-- Check for mini.icons first
	local mini_icons_ok, mini_icons = pcall(require, "mini.icons")
	if mini_icons_ok then
		return {
			get = function(ft, filename)
				local category = ft ~= "" and "filetype" or "file"
				local input = ft ~= "" and ft or filename
				local icon, color = mini_icons.get(category, input)
				return icon, color
			end,
		}
	end

	local web_devicons_ok, web_devicons = pcall(require, "nvim-web-devicons")
	if web_devicons_ok then
		return {
			get = function(ft, filename, extension)
				local icon, color = web_devicons.get_icon(filename, extension) -- Extract icon, discard color here
				return icon, color
			end,
		}
	end
end

function M.get_icon()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")
	local ft = vim.bo.filetype

	local provider = get_icon_provider()

	if provider == nil then
		return nil, nil
	end

	local icon, color = provider.get(ft, filename, extension)
	return icon, color
end

function M.get_filetype_icon()
	local icon, color = M.get_icon()

	local hl = vim.api.nvim_get_hl_by_name("StreamlineFiletype", true)

	if color ~= nil then
		add_background_to_highlight(color, hl.background)
	end

	if icon == nil then
		return ""
	else
		return " %#StreamlineFiletypeIcon#" .. icon .. " "
	end
end

return M
