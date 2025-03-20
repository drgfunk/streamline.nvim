local M = {}

function M.setup()
  vim.api.nvim_create_user_command("StreamlineReplace", function()
    require("snacks").input.input({
      prompt = "Replace: ",
      win = {
        keys = {
          i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
        },
        wo = {
          winhighlight = "SnacksInputNormal:SnacksPickerInput,SnacksInputTitle:SnacksPickerTitle",
        },
      },
    }, function(result)
      -- if result is nil or empty, do nothing
      if not result or result == "" then
        return
      end
      M.replace(result)
    end)
  end, {})
end

function M.replace(new_word)
  -- Store the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Get the current word under cursor
  local current_word = vim.fn.expand("<cword>")

  -- Escape special characters in the current word to avoid regex issues
  -- local escaped_word = vim.fn.escape(current_word, [[/\.*$^~[]]])

  -- Create the substitute command
  local cmd = string.format("silent %%s/\\<%s\\>/%s/g", current_word, new_word)

  -- Execute the substitution
  vim.cmd(cmd)

  -- Clear the search highlight
  vim.api.nvim_set_option_value("hlsearch", false, {})

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)

  -- Optional: Print feedback
  local msg = string.format("Replaced all instances of '%s' with '%s'", current_word, new_word)

  vim.notify(msg, vim.log.levels.INFO, {
    title = "Streamline Replace",
  })
end

return M
