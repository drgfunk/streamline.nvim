local M = {}
local utils = require("streamline.utils")
local spinner = require("streamline.spinner")

local state = {
  state = "",
  name = "",
  spinner_id = "CodeCompanion",
}

function M.codecompanion()
  local spinner_id = state.spinner_id
  local name = state.name or "CodeCompanion"

  local spinnerStr = spinner.spinner(spinner_id)
  local codeCompanionState = state.state

  local state_actions = {
    ["CodeCompanionRequestStarted"] = {
      message = " is thinking",
      action = "display",
    },
    ["CodeCompanionRequestStartedInlineStarted"] = {
      message = " is thinking",
      action = "display",
    },
    ["CodeCompanionRequestStreaming"] = {
      message = " is responding",
      action = "display",
    },
    ["CodeCompanionRequestFinished"] = {
      action = "stop_spinner",
    },
  }

  local state_info = state_actions[codeCompanionState]
  if state_info then
    if state_info.action == "display" then
      return spinnerStr .. utils.styled("StreamlineCodecompanionText", " " .. name .. state_info.message)
    elseif state_info.action == "stop_spinner" then
      spinner.stop(state.spinner_id)
    end
  end

  return ""
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  -- Define event mappings
  local spinner_start_events = {
    ["CodeCompanionRequestStarted"] = true,
    ["CodeCompanionRequestStreaming"] = true,
    ["CodeCompanionRequestStartedInlineStarted"] = true,
  }

  local spinner_stop_events = {
    ["CodeCompanionRequestFinished"] = true,
    ["CodeCompanionInlineFinished"] = true,
  }

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      local name = request.data and request.data.adapter.formatted_name or "unknown"
      local spinner_id = state.spinner_id

      state.state = request.match
      state.name = name

      if spinner_start_events[request.match] then
        require("streamline.spinner").start(spinner_id, "dotProgressSpinner")
      elseif spinner_stop_events[request.match] then
        require("streamline.spinner").stop(spinner_id)
      end
    end,
  })
end

M.setup()

return M
