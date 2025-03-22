local M = {}
local utils = require("streamline.utils")

function M.git_branch()
  local branch = utils.get_branch_name(20)

  if branch == "" then
    return ""
  end

  return utils.styled("StreamlineGitBranch", "  " .. branch)
end

return M
