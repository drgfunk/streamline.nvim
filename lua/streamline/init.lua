-- luacheck: globals vim

---@class StreamlineSection
---@field left string[]|function[] Components for the left section
---@field middle string[]|function[] Components for the middle section
---@field right string[]|function[] Components for the right section

---@class StreamlineConfig
---@field icon_provider string The icon provider to use
---@field sections StreamlineSection Configuration for statusline sections
---@field excluded_filetypes string[] Filetypes where the statusline should be hidden

local M = {}
local uv = vim.loop

-- Default configuration
---@type StreamlineConfig
M.defaults = {
  icon_provider = "mini.icons",
  sections = {
    left = {
      "mode",
      "git_branch",
      "filename",
    },
    middle = {
      "macro",
      "spinner",
    },
    right = {
      "indent",
      "filetype",
    },
  },
  excluded_filetypes = {
    "TelescopePrompt",
    "snacks_picker_input",
    "snacks_picker_list",
    "help",
  },
}

---@type StreamlineConfig
M.options = {}

-- Main setup function
---@param opts? StreamlineConfig User configuration to override defaults
function M.setup(opts)
  require("streamline.highlights").setup()
  require("streamline.replace").setup()
  require("streamline.js-convert-require").setup()

  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

  -- Initial render
  M.render()

  require("streamline.components").start_spinner("Processing...")
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

    -- Reset highlight group after each component to avoid carry-over
    table.insert(result, "%#Streamline#")
  end
  return table.concat(result, "")
end

M.render = vim.schedule_wrap(function()
  local ft = vim.bo.filetype

  -- hide statusline if filetype is in excluded_filetypes
  if vim.tbl_contains(M.options.excluded_filetypes, ft) then
    return ""
  end

  local left = process_section(M.options.sections.left)
  local middle = process_section(M.options.sections.middle)
  local right = process_section(M.options.sections.right)

  -- Calculate the visual width of strings with escape sequences
  local function visual_width(str)
    -- Remove highlighting commands and other non-visible characters
    local cleaned = str:gsub("%%#[^#]+#", ""):gsub("%%{.-%}", ""):gsub("%%[xXbBuUdDoctTfF]", " ")
    return vim.fn.strdisplaywidth(cleaned)
  end

  local middle_width = visual_width(middle)

  -- Create a centered statusline using manual padding if needed
  local statusline = string.format(
    "%%<%s%%=%%{repeat(' ', (&columns / 2 - %d / 2 - %d))}%s%%{repeat(' ', (&columns / 2 - %d / 2 - %d))}%%=%s",
    left,
    middle_width,
    visual_width(left), -- Left padding calculation
    middle,
    middle_width,
    visual_width(right), -- Right padding calculation
    right
  )

  if statusline == "" then
    return
  end

  vim.api.nvim_set_option_value("statusline", statusline, {})
end)

function M.streamline_augroup()
  -- Set up autocommand for updates
  local group = vim.api.nvim_create_augroup("streamline", { clear = true })
  vim.api.nvim_create_autocmd({
    "ColorScheme",
    "ModeChanged",
    "WinEnter",
    "BufEnter",
    "WinLeave",
    "BufLeave",
    "BufReadPost",
    "BufWritePost",
    "BufModifiedSet",
    "RecordingEnter",
    "RecordingLeave",
  }, {
    group = group,
    pattern = "*",
    callback = function()
      M.load_streamline()
    end,
  })
end

return M
