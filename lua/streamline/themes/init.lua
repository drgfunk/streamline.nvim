-- lua/streamline/themes/init.lua

local M = {}
local streamline_groups = {} -- Track our highlight groups

-- Apply a theme's highlight groups
function M.apply_theme(theme_highlights)
  -- Store the list of highlight groups we're managing
  streamline_groups = {}
  for group_name, hl_config in pairs(theme_highlights) do
    vim.api.nvim_set_hl(0, group_name, hl_config)
    table.insert(streamline_groups, group_name)
  end
end

-- Clear only Streamline highlights
function M.clear_highlights()
  for _, group_name in ipairs(streamline_groups) do
    pcall(vim.api.nvim_set_hl, 0, group_name, {})
  end
end

-- Try to load a specific theme
function M.try_load_theme(theme_name)
  local ok, theme = pcall(require, "streamline.themes." .. theme_name)
  if ok and theme.get_highlights then
    M.apply_theme(theme.get_highlights())
    return true
  end
  return false
end

-- Check if a colorscheme matches any in a list
local function is_using_colorscheme(colorscheme_list)
  -- loop through the list of colorschemes
  local current = vim.g.colors_name or ""
  for _, scheme in ipairs(colorscheme_list) do
    -- check if the current colorscheme matches the current scheme
    if scheme == current then
      return true
    end
  end

  return false
end

-- Reload the appropriate theme based on current state
function M.reload_theme()
  -- Clear existing Streamline highlights
  M.clear_highlights()

  -- load default theme
  local ok, theme = pcall(require, "streamline.themes.default")
  if ok and theme.get_highlights then
    M.apply_theme(theme.get_highlights())
  end

  -- Try to load rose-pine if available and active
  local rose_pine_available = pcall(require, "rose-pine.palette")
  if rose_pine_available and is_using_colorscheme({ "rose-pine", "test" }) then
    M.try_load_theme("rose-pine")
    return
  end
end

-- Setup themes
function M.setup()
  -- Initial theme loading
  M.reload_theme()

  -- Create autocmd to detect background changes
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      -- Reload the appropriate theme
      M.reload_theme()
    end,
    desc = "Reload Streamline theme when background changes",
  })
end

return M
