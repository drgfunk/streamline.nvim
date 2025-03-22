local M = {}
local utils = require("streamline.utils")

function M.filename()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_name = vim.fn.bufname(current_buf)

  if current_name == "" then
    -- return "[No Name]"
    return utils.styled("StreamlineFilename", "[No Name]")
  end

  -- Check if buffer is a scratch buffer
  if string.match(string.lower(current_name), "nvim/scratch") then
    current_name = "Scratch"
  end

  local base_name = vim.fn.fnamemodify(current_name, ":t")
  local needs_disambiguation = false

  -- Check other buffers for same filename
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf and vim.fn.buflisted(buf) == 1 then
      -- local buf_name = vim.fn.bufname(buf)
      local other_base = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")

      if base_name == other_base then
        needs_disambiguation = true
        break
      end
    end
  end

  if needs_disambiguation then
    -- Add parent directory
    base_name = vim.fn.fnamemodify(current_name, ":h:t") .. "/" .. base_name
  end

  if #base_name > 20 then
    base_name = "..." .. base_name:sub(-20)
  end

  local modified_indicator = vim.bo.modified and "%#StreamlineModified# 󰧞" or ""

  return table.concat({
    "%#StreamlineFilename#",
    "  ",
    base_name,
    modified_indicator,
    "  ",
  })
end

return M
