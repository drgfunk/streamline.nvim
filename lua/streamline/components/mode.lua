-- luacheck: globals vim
local M = {}
local utils = require("streamline.utils")

function M.mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = utils.get_mode_name(mode)

  return utils.styled("StreamlineMode", " " .. string.upper(mode_name))
end

return M
