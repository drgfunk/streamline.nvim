-- luacheck: globals vim
local M = {}

M.mode = require("streamline.components.mode").mode
M.git_branch = require("streamline.components.git_branch").git_branch
M.filename = require("streamline.components.filename").filename
M.filetype = require("streamline.components.filetype").filetype
M.indent = require("streamline.components.indent").indent
M.macro = require("streamline.components.macro").macro
M.codecompanion = require("streamline.components.codecompanion").codecompanion

return M
