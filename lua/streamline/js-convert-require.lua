local M = {}

function M.setup()
  -- Define the <Plug> mapping first - this is critical for vim-repeat
  vim.cmd(
    [[nnoremap <silent> <Plug>(StreamlineConvertRequire) :<C-u>lua require("streamline.js-convert-require").convert_require_to_import()<CR>]]
  )

  -- Create the user command that uses the <Plug> mapping
  vim.api.nvim_create_user_command("StreamlineConvertRequire", function()
    vim.cmd([[normal! <Plug>(StreamlineConvertRequire)]])
  end, {})

  -- Optional: provide a suggested mapping that users can add to their config
  -- vim.keymap.set("n", "<Leader>cr", "<Plug>(StreamlineConvertRequire)", { silent = true })
end

function M.convert_require_to_import()
  -- Check if we're in a JavaScript file
  local filetype = vim.bo.filetype
  if
    filetype ~= "javascript"
    and filetype ~= "javascriptreact"
    and filetype ~= "typescript"
    and filetype ~= "typescriptreact"
  then
    vim.notify("This command only works in JavaScript/TypeScript files", vim.log.levels.WARN, {
      title = "Streamline JS Helper",
    })
    return
  end

  -- Get the current line
  local line_nr = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]

  -- Pattern match for CommonJS require
  local pattern = "^%s*const%s+([%w_]+)%s*=%s*require%(%s*[\"']([^\"']+)[\"']%s*%)%s*"

  -- Extract variable name and module path
  local var_name, module_path = line:match(pattern)

  -- If there's no match, notify and return
  if not var_name or not module_path then
    vim.notify("No CommonJS require statement found on this line", vim.log.levels.WARN, {
      title = "Streamline JS Helper",
    })
    return
  end

  -- Create the import statement
  local import_statement = string.format('import %s from "%s"', var_name, module_path)

  -- Replace the line
  vim.api.nvim_buf_set_lines(0, line_nr - 1, line_nr, false, { import_statement })

  -- Make it repeatable
  pcall(function()
    -- Only try to set repeat if the plugin exists
    vim.cmd([[silent! call repeat#set("\<Plug>(StreamlineConvertRequire)", v:count)]])
  end)

  -- Notify the user
  local msg = string.format("Converted to: '%s'", import_statement)
  vim.notify(msg, vim.log.levels.INFO, {
    title = "Streamline JS Helper",
  })
end

return M
