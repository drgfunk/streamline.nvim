local M = {}
local utils = require("streamline.utils")

function M.filename()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_name = vim.fn.bufname(current_buf)

  if current_name == "" then
    -- return "[No Name]"
    return utils.styled("StreamlineFilename", "[No Name]")
  end

  -- Define special buffer patterns and their display names
  local special_buffers = {
    { "nvim/scratch", "Scratch" },
    { "codecompanion", "Code Companion" },
  }

  -- Check if buffer matches any special pattern
  for _, buffer_info in ipairs(special_buffers) do
    local pattern, display_name = buffer_info[1], buffer_info[2]
    if string.match(string.lower(current_name), pattern) then
      current_name = display_name
      break
    end
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

  -- Smart truncation of filename
  local function calculate_max_filename_Length()
    local win_width = vim.api.nvim_win_get_width(0)
    local percentage = 0.3 -- 30% of window width
    local calculated_length = math.floor(win_width * percentage)

    -- Set reasonable bounds
    local min_length = 16
    local max_length = 60

    return math.max(min_length, math.min(max_length, calculated_length))
  end

  local max_length = calculate_max_filename_Length()

  if #base_name > max_length then
    -- Extract file extension if present
    local name_part, ext_part = base_name:match("(.*)%.([^%.]+)$")

    if name_part and ext_part then
      -- If we have an extension, preserve it and parts of the name
      local ellipsis = "..."
      local ext_with_dot = "." .. ext_part
      local avail_length = max_length - #ellipsis - #ext_with_dot

      if avail_length >= 6 then
        -- Keep parts from both beginning and end of name
        local start_len = math.ceil(avail_length * 0.6) -- 60% from start
        local end_len = avail_length - start_len -- 40% from end

        if end_len >= 2 then
          base_name = name_part:sub(1, start_len) .. ellipsis .. name_part:sub(-end_len) .. ext_with_dot
        else
          -- Not enough space for end, use more from beginning
          base_name = name_part:sub(1, avail_length) .. ellipsis .. ext_with_dot
        end
      else
        -- Very short available space, truncate simpler
        base_name = name_part:sub(1, math.max(1, avail_length)) .. ellipsis .. ext_with_dot
      end
    else
      -- No extension, balanced truncation
      local ellipsis = "..."
      local start_chars = math.ceil((max_length - #ellipsis) * 0.6)
      local end_chars = max_length - #ellipsis - start_chars
      base_name = base_name:sub(1, start_chars) .. ellipsis .. base_name:sub(-end_chars)
    end
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
