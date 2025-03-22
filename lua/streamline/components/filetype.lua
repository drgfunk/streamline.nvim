local M = {}
local utils = require("streamline.utils")

function M.filetype()
  local icon = utils.get_filetype_icon()
  local ft = vim.bo.filetype

  if ft == "" then
    ft = "plain"
  end

  return utils.styled("StreamlineFiletype", icon) .. utils.styled("StreamlineFiletype", ft)
end

return M
