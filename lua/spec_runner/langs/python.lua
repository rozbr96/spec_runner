
local utils = require('spec_runner.utils')

Python = {}

local function token_name(line, token_type)
  local token = table.remove(utils.split(line, token_type), 2)
  token = table.remove(utils.split(token, '%('), 1)
  token = utils.strip(token)
  return token
end

function Python.get_current_cursor_spec_starting_line()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  local class_name = nil
  local function_name = nil
  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line > 0 do
    local line = vim.api.nvim_buf_get_lines(buf, start_line, start_line + 1, false)[1]
    local stripped_line = utils.strip(line)

    if first_code_line_tab_index == nil and line ~= nil then
      first_code_line_tab_index = string.find(line, '%S')
      first_code_line_tab_index = (first_code_line_tab_index or 0) + (is_first_line and 1 or 0)
    end

    if utils.starts_with(stripped_line, 'def test_') or (
      utils.starts_with(stripped_line, 'class ')
        and utils.contains(stripped_line, 'Test')
    ) then
      local current_line_tab_index = string.find(line, '%S')

      if current_line_tab_index < first_code_line_tab_index then
        if utils.starts_with(stripped_line, 'def') and function_name == nil then
          function_name = token_name(stripped_line, 'def')
        elseif utils.starts_with(stripped_line, 'class') and class_name == nil then
          class_name = token_name(stripped_line, 'class')
        end
      end
    end

    if class_name ~= nil then
      break
    end

    start_line = start_line - 1
    is_first_line = false
  end

  local target = string.gsub(vim.fn.expand('%'), '/', '.')
  target = string.gsub(target, '.py$', '')

  if class_name ~= nil then
    target = target .. '.' .. class_name

    if function_name ~= nil then
      target = target .. '.' .. function_name
    end
  end

  return target
end

function Python.get_target_spec(_, target_spec)
  return target_spec
end

return Python

