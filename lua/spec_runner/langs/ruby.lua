
local utils = require('spec_runner.utils')

Ruby = {}

-- TODO if outside a spec, get parent context instead of previous sibling
function Ruby.get_current_cursor_spec_starting_line()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  local start_line = cursor[1] - 1

  while start_line > 0 do
    local line = vim.api.nvim_buf_get_lines(buf, start_line, start_line + 1, false)[1]
    line = utils.strip(line)

    if utils.starts_with(line, 'it')
      or utils.starts_with(line, 'context')
      or utils.starts_with(line, 'describe')
      or utils.starts_with(line, 'RSpec.describe') then
        return start_line + 1
      end

    start_line = start_line - 1
  end

  return 1
end

function Ruby.get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Ruby

