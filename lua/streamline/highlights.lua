-- luacheck: globals vim
local M = {}

function M.setup()
  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local warning_hl = vim.api.nvim_get_hl(0, { name = "WarningMsg" })

  -- Default colors
  vim.api.nvim_set_hl(0, "Streamline", { link = "Normal" })
  vim.api.nvim_set_hl(0, "StreamlineFilename", { fg = comment_hl.fg, bg = normal_hl.bg })
  vim.api.nvim_set_hl(0, "StreamlineFiletype", { link = "StatusLine" })
  vim.api.nvim_set_hl(0, "StreamlineGitBranch", { link = "StatusLineNC" })
  vim.api.nvim_set_hl(0, "StreamlineIndent", { bg = normal_hl.bg, fg = comment_hl.fg })
  vim.api.nvim_set_hl(0, "StreamlineMode", { link = "StatusLine" })
  vim.api.nvim_set_hl(0, "StreamlineModified", { fg = warning_hl.fg, bg = normal_hl.bg })
  vim.api.nvim_set_hl(0, "StreamlineMacro", { link = "StatusLine" })
  vim.api.nvim_set_hl(0, "StreamlineMacroText", { link = "StatusLine" })
  vim.api.nvim_set_hl(0, "StreamlineMacroIcon", { link = "StatusLine" })

  -- import rose-pine colors and if found, use them
  local ok, rose_pine = pcall(require, "rose-pine.palette")
  if ok then
    vim.api.nvim_set_hl(0, "StreamlineFilename", { fg = rose_pine.muted, bg = rose_pine.transparent })
    vim.api.nvim_set_hl(0, "StreamlineFiletype", { fg = rose_pine.base, bg = rose_pine.text })
    vim.api.nvim_set_hl(0, "StreamlineGitBranch", { fg = rose_pine.text, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineIndent", { fg = rose_pine.muted, bg = rose_pine.transparent })
    vim.api.nvim_set_hl(0, "StreamlineMode", { fg = rose_pine.base, bg = rose_pine.text })
    vim.api.nvim_set_hl(0, "StreamlineModified", { fg = rose_pine.gold, bg = rose_pine.transparent })
    vim.api.nvim_set_hl(0, "StreamlineMacro", { bg = rose_pine.surface })
    vim.api.nvim_set_hl(0, "StreamlineMacroText", { fg = rose_pine.subtle, bg = rose_pine.surface })
    vim.api.nvim_set_hl(0, "StreamlineMacroIcon", { fg = rose_pine.love, bg = rose_pine.surface })
    vim.api.nvim_set_hl(0, "StreamlineSpinner", { fg = rose_pine.foam, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineSpinnerText", { fg = rose_pine.subtle, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineRecordingIcon", { fg = rose_pine.love, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineRecording", { fg = rose_pine.love, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineCodecompanionText", { fg = rose_pine.subtle, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineCodecompanionSpinnerOn", { fg = rose_pine.subtle, bg = rose_pine.overlay })
    vim.api.nvim_set_hl(0, "StreamlineCodecompanionSpinnerOff", { fg = "#403d52", bg = rose_pine.overlay })
  end
end

return M
