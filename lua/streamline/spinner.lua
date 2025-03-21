local M = {}
local utils = require("streamline.utils")

local spinner_frames = { " ◜", " ◠", " ◝", " ◞", " ◡", " ◟" }

-- Store all spinners in a table indexed by ID
local spinners = {}
-- Global timer for all spinners
local global_timer = nil

-- Create a new spinner instance
function M.create(id, frames, spinner_hl)
  -- Create a new spinner if it doesn't already exist
  if not spinners[id] then
    spinners[id] = {
      active = false,
      frame = 1,
      frames = frames,
      spinner_hl = spinner_hl or "StreamlineSpinner",
    }
  end
  return id
end

-- Start a spinner by ID
function M.start(id, frames, spinner_hl)
  -- Create spinner if it doesn't exist
  if not spinners[id] then
    M.create(id, frames, spinner_hl)
  end

  -- Update spinner state
  spinners[id].active = true
  spinners[id].frame = 1
  if spinner_hl then
    spinners[id].spinner_hl = spinner_hl
  end

  -- Create global timer only if needed
  if not global_timer then
    global_timer = vim.loop.new_timer()
    if global_timer then
      global_timer:start(
        0,
        100,
        vim.schedule_wrap(function()
          local any_active = false

          -- Update all active spinners
          for _, spinner in pairs(spinners) do
            if spinner.active then
              local frms = spinner.frames or spinner_frames
              any_active = true
              spinner.frame = (spinner.frame % #frms) + 1
            end
          end

          -- If any spinner is active, update the statusline
          if any_active then
            require("streamline").load_streamline()
          else
            -- Stop timer if no active spinners
            if global_timer then
              global_timer:stop()
              global_timer:close()
              global_timer = nil
            end
          end
        end)
      )
    end
  end
end

-- Stop a spinner by ID
function M.stop(id)
  if spinners[id] then
    spinners[id].active = false
  end

  -- Check if any spinners are still active
  local any_active = false
  for _, spinner in pairs(spinners) do
    if spinner.active then
      any_active = true
      break
    end
  end

  -- If no active spinners, stop and clean up the timer
  if not any_active and global_timer then
    global_timer:stop()
    global_timer:close()
    global_timer = nil
  end

  pcall(vim.api.nvim_command, "redrawstatus")
end

-- Get a string representation of all active spinners
function M.spinner(id)
  -- If an ID is provided, return that specific spinner
  if id and spinners[id] then
    local spinner = spinners[id]
    if not spinner.active then
      return ""
    end

    local frames = spinner.frames or spinner_frames
    local frame = frames[spinner.frame]
    return utils.styled(spinner.spinner_hl, "" .. frame)
  end

  return ""
end

-- Legacy functions for backward compatibility
function M.start_spinner()
  M.start("default")
end

function M.stop_spinner()
  M.stop("default")
end

return M
