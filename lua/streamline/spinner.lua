local M = {}
local utils = require("streamline.utils")

-- local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_frames = { "◜", "◠", "◝", "◞", "◡", "◟" }
-- local spinner_frames = { "◓", "◑", "◒", "◐" }

local spinner = {
  active = false,
  frame = 1,
  text = "Loading",
  timer = nil,
}

function M.spinner()
  if not spinner.active then
    return ""
  end

  local frame = spinner_frames[spinner.frame]
  return utils.styled("StreamlineSpinner", frame .. " " .. spinner.text)
end

function M.start_spinner(text)
  spinner.active = true
  spinner.frame = 1
  spinner.text = text or "Loading"

  -- Create timer only if needed
  if not spinner.timer then
    spinner.timer = vim.loop.new_timer()
    spinner.timer:start(
      0,
      100,
      vim.schedule_wrap(function()
        if spinner.active then
          spinner.frame = (spinner.frame % #spinner_frames) + 1
          -- Use pcall to safely update statusline
          require("streamline").load_streamline()
        end
      end)
    )
  end
end

function M.stop_spinner()
  spinner.active = false

  -- Stop and clean up the timer when not needed
  if spinner.timer then
    spinner.timer:stop()
    spinner.timer:close()
    spinner.timer = nil
  end

  pcall(vim.api.nvim_command, "redrawstatus")
end

return M
