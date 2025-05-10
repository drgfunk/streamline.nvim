-- lua/streamline/themes/default.lua
-- luacheck: globals vim

local M = {}

function M.get_highlights()
  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  local warning_hl = vim.api.nvim_get_hl(0, { name = "WarningMsg" })
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })

  return {
    Streamline = { link = "Normal" },
    StreamlineBar = { link = "Normal" }, -- Background for the Streamline bar
    StreamlineFilename = { fg = comment_hl.fg, bg = normal_hl.bg },
    StreamlineModified = { fg = warning_hl.fg, bg = normal_hl.bg },
    StreamlineFiletype = { link = "StatusLine" },
    StreamlineGitBranch = { link = "StatusLineNC" },
    StreamlineIndent = { bg = normal_hl.bg, fg = comment_hl.fg },
    StreamlineMode = { link = "StatusLine" },
    StreamlineMacro = { link = "StatusLine" },
    StreamlineMacroText = { link = "StatusLine" },
    StreamlineMacroIcon = { link = "StatusLine" },
    StreamlineSpinnerRecordingOff = { link = "StatusLine" },
    StreamlineSpinnerRecordingOn = { fg = "red", bg = statusline_hl.bg },
    StreamlineSpinnerCircle = { link = "StatusLine" },
    StreamlineCodecompanionText = { link = "StatusLine" },
    StreamlineSpinnerDotProgressOff = { link = "StatusLine" },
    StreamlineSpinnerDotProgressOn = { fg = "gray", bg = statusline_hl.bg },
    StreamlineConformEnabled = { fg = comment_hl.fg, bg = normal_hl.bg },
    StreamlineConformDisabled = { fg = "gray", bg = normal_hl.bg },
  }
end

return M
