local M = {}
local utils = require("streamline.utils")

function M.setup()
  -- Set up autocommand for macro recording
  local group = vim.api.nvim_create_augroup("MacroRecording", {})
  local recording_icon_frames = { "󰑋", "󰑋", "󰑋", "󰑋", "󰑋", " ", " ", " ", " ", " " }

  vim.api.nvim_create_autocmd({ "RecordingEnter" }, {
    group = group,
    pattern = "*",
    callback = function()
      require("streamline.spinner").start("macro", recording_icon_frames, "StreamlineRecordingIcon")
    end,
  })

  vim.api.nvim_create_autocmd({ "RecordingLeave" }, {
    group = group,
    pattern = "*",
    callback = function()
      require("streamline.spinner").stop("macro")
    end,
  })
end

function M.macro()
  local recording_register = vim.fn.reg_recording()

  if recording_register == "" then
    return ""
  end

  local spinner = require("streamline.spinner").spinner("macro")

  return utils.styled("StreamlineMacro", " ")
    .. spinner
    .. utils.styled("StreamlineMacroText", "Recording @" .. recording_register)
end

M.setup()

return M
