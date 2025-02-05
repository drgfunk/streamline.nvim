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

function M.get_icon()
	local filename = vim.fn.expand("%:t")
	local extension = vim.fn.expand("%:e")

	local icon, color = require("nvim-web-devicons").get_icon_color(filename, extension)
	return icon, color
end

function M.get_filetype_icon()
	local icon, color = M.get_icon()

	-- get background color from StreamlineMode hl group as hex color
	-- make a copy of the StreamlineMode hl group
	local hl = vim.api.nvim_get_hl_by_name("StreamlineMode", true)

	-- apply hl to the icon string
	local bg_color = string.format("%x", hl.background)

	if icon == nil then
		return ""
	else
		vim.cmd([[hi StatusLineFTIconColor guifg=]] .. color .. [[ guibg=#]] .. bg_color)
		return "%#StatusLineFTIconColor# " .. icon .. " "
	end
end

-- Add other utility functions
return M
