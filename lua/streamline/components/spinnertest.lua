local M = {}
local utils = require("streamline.utils")

function M.spinnertest()
  local spinner = require("streamline.spinner").spinner("spinnertest")
  local spinnerRecord = require("streamline.spinner").spinner("spinnertestRecord")
  local spinnerDot = require("streamline.spinner").spinner("spinnertestDot")
  return spinner
    .. utils.styled("Normal", " ")
    .. spinnerRecord
    .. utils.styled("Normal", " ")
    .. spinnerDot
    .. utils.styled("StreamlineSpinnerTest", " Spinner Test")
end

function M.setup()
  require("streamline.spinner").start("spinnertest")
  require("streamline.spinner").start("spinnertestRecord", "recordingButton")
  require("streamline.spinner").start("spinnertestDot", "dotProgressSpinner")
end

M.setup()

return M
