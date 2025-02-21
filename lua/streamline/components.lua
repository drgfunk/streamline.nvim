-- luacheck: globals vim
local M = {}

function M.mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = require("streamline.utils").get_mode_name(mode)

  return table.concat({ "%#StreamlineMode#", " ", string.upper(mode_name), " " })
end

function M.git_branch()
  local branch = require("streamline.utils").get_branch_name(20)
  return table.concat({ "%#StreamlineGitBranch#", "  ", branch, " " })
end

function M.filename()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_name = vim.fn.bufname(current_buf)

  if current_name == "" then
    return "[No Name]"
  end

  -- Check if buffer is a scratch buffer
  if string.match(string.lower(current_name), "nvim/scratch") then
    current_name = "Scratch"
  end

  local base_name = vim.fn.fnamemodify(current_name, ":t")

  -- Check other buffers for same filename
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.fn.buflisted(buf) == 1 then
      local buf_name = vim.fn.bufname(buf)
      local other_base = vim.fn.fnamemodify(buf_name, ":t")

      if base_name == other_base then
        -- Add parent directory
        base_name = vim.fn.fnamemodify(current_name, ":h:t") .. "/" .. base_name
      end
    end
  end

  if #base_name > 20 then
    base_name = "..." .. base_name:sub(-20)
  end

  return table.concat({
    "%#StreamlineFilename#",
    "  ",
    base_name,
    vim.bo.modified and "%#StreamlineModified# 󰧞" or "",
    "  ",
  })
end

function M.filetype()
  local icon = require("streamline.utils").get_filetype_icon()
  local ft = vim.bo.filetype

  return table.concat({ "%#StreamlineFiletype#", icon, " %#StreamlineFiletype#", ft, " " })
end

function M.indent()
  local tabs = "󰌒 Tabs"
  local spaces = "󱁐 Spaces"

  return table.concat({
    "%#StreamlineIndent#  ",
    vim.bo.expandtab and spaces or tabs,
    "  ",
  })
end

local is_requesting = false

function M.set_compainion_state(state)
  is_requesting = state
end

function M.companion_status()
  if not is_requesting then
    return ""
  end

  return table.concat({
    "%#StreamlineCompanion#",
    "  󰚩 ", -- You can change this icon to match your theme
    " ",
  })
end

return M
