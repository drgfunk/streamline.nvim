-- lua/streamline/themes/init.lua
-- luacheck: globals vim

local M = {}

-- Apply a theme's highlight groups
function M.apply_theme(theme_highlights)
  for group_name, hl_config in pairs(theme_highlights) do
    vim.api.nvim_set_hl(0, group_name, hl_config)
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

-- Setup themes
function M.setup()
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

  -- Could add config option here to load other themes by user preference
end

return M
