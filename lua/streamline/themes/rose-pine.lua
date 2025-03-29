-- lua/streamline/themes/rose-pine.lua
local M = {}

function M.get_highlights()
  local rose_pine = require("rose-pine.palette")
  return {
    StreamlineBar = { bg = "NONE" }, -- Background for the Streamline bar
    StreamlineFilename = { fg = rose_pine.muted, bg = rose_pine.transparent },
    StreamlineFiletype = { fg = rose_pine.base, bg = rose_pine.text },
    StreamlineGitBranch = { fg = rose_pine.text, bg = rose_pine.overlay },
    StreamlineIndent = { fg = rose_pine.muted, bg = rose_pine.transparent },
    StreamlineMode = { fg = rose_pine.base, bg = rose_pine.text },
    StreamlineModified = { fg = rose_pine.gold, bg = rose_pine.transparent },
    StreamlineMacro = { bg = rose_pine.overlay },
    StreamlineMacroText = { fg = rose_pine.subtle, bg = rose_pine.overlay },
    StreamlineMacroIcon = { fg = rose_pine.love, bg = rose_pine.surface },
    StreamlineSpinnerCircle = { fg = rose_pine.foam, bg = rose_pine.overlay },
    StreamlineSpinnerRecordingOn = { fg = rose_pine.love, bg = rose_pine.overlay },
    StreamlineSpinnerRecordingOff = { fg = rose_pine.base, bg = rose_pine.overlay },
    StreamlineCodecompanionText = { fg = rose_pine.subtle, bg = rose_pine.overlay },
    StreamlineSpinnerDotProgressOn = { fg = rose_pine.subtle, bg = rose_pine.overlay },
    StreamlineSpinnerDotProgressOff = { fg = rose_pine.highlight_med, bg = rose_pine.overlay },
  }
end

return M
