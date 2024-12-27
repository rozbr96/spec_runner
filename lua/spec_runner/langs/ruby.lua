
local utils = require('spec_runner.utils')

Ruby = {}

function Ruby.get_current_cursor_spec_starting_line()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line > 0 do
    local line = vim.api.nvim_buf_get_lines(buf, start_line, start_line + 1, false)[1]
    local stripped_line = utils.strip(line)

    if first_code_line_tab_index == nil and line ~= '' then
      first_code_line_tab_index = string.find(line, '%S')
      first_code_line_tab_index = first_code_line_tab_index + (is_first_line and 1 or 0)
    end

    if utils.starts_with(stripped_line, 'it ')
      or utils.starts_with(stripped_line, 'context ')
      or utils.starts_with(stripped_line, 'describe ')
      or utils.starts_with(stripped_line, 'RSpec.describe ') then
        local current_line_tab_index = string.find(line, '%S')

        if current_line_tab_index < first_code_line_tab_index then
          return start_line + 1
        end
      end

    start_line = start_line - 1
    is_first_line = false
  end

  return 1
end

function Ruby.get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Ruby

