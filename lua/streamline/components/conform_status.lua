-- luacheck: globals vim
local M = {}

function M.conform_status()
  -- Safe check for Conform plugin
  local ok, _ = pcall(require, "conform")
  if not ok then
    return ""
  end

  -- Check if we're in a file that could be formatted
  local ft = vim.bo.filetype
  if ft == "" then
    return ""
  end

  -- Check if formatting is disabled
  local disabled = vim.g.disable_autoformat == true
  local bufnr = vim.api.nvim_get_current_buf()

  ok, local_disabled = pcall(function()
    return vim.b[bufnr].disable_autoformat == true
  end)

  if ok and local_disabled then
    disabled = true
  end

  -- Only show icon when formatting is enabled
  if not disabled then
    return "%#StreamlineConformEnabled#󰉢  %#StreamlineBar#"
  else
    return "%#StreamlineConformDisabled#󰉠  %#StreamlineBar#"
  end

  return ""
end

return M
