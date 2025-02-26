-- luacheck: globals vim

local M = {}
local uv = vim.loop

-- Default configuration
M.defaults = {
  icon_provider = "mini.icons",
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
    "snacks_picker_list",
    "help",
  },
}

M.options = {}

-- Main setup function
function M.setup(opts)
  require("streamline.highlights").setup()
  require("streamline.replace").setup()

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

    -- Reset highlight group after each component to avoid carry-over
    table.insert(result, "%#Streamline#")
  end
  return table.concat(result, "")
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

  local statusline = table.concat(sections, "")

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
  }, {
    group = group,
    pattern = "*",
    callback = function()
      M.load_streamline()
    end,
  })
end

return M
