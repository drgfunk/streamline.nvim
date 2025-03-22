local M = {}
local utils = require("streamline.utils")

function M.indent()
  local tabs = "󰌒 Tabs "
  local spaces = "󱁐 Spaces "

  return utils.styled("StreamlineIndent", vim.bo.expandtab and spaces or tabs)
end

return M
