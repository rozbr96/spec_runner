
local utils = require('spec_runner.utils')

Base = {}

function Base.get_current_cursor_starting_line(test_block_starters)
  local buffer = vim.api.nvim_get_current_buf()
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)

  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line > 0 do
    local line_content = vim.api.nvim_buf_get_lines(buffer, start_line, start_line + 1, false)[1]
    local stripped_line_content = utils.strip(line_content)

    if first_code_line_tab_index == nil and line_content ~= '' then
      first_code_line_tab_index = string.find(line_content, '%S')
      first_code_line_tab_index = first_code_line_tab_index + (is_first_line and 1 or 0)
    end

    for index = 1, #test_block_starters do
      if utils.starts_with(stripped_line_content, test_block_starters[index]) then
        local current_line_tab_index = string.find(line_content, '%S')

        if current_line_tab_index < first_code_line_tab_index then
          return start_line + 1
        end
      end
    end

    start_line = start_line - 1
    is_first_line = false
  end

  return 1
end

return Base
