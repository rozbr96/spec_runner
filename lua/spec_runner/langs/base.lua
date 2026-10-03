local utils = require('spec_runner.utils')

---BaseRunner spec runner
---@class Runner
local BaseRunner = {}

---Returns the starting line number for the current spec block
---
---If the cursor current position is not within a spec block, then first line reference is returned
---@param test_block_starters string[] The prefix indications which represent spec blocks, like "`RSpec.describe`" or "`def test_`"
---@return number
function BaseRunner.get_current_cursor_starting_line(test_block_starters)
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

---MUST BE IMPLEMENTED BY THE RUNNER
---
---Builds the full targetted spec identification, along with path and line number
---
---@param filename string The targeted spec file
---@param line string | number The targeted spec line number
---@return string
function BaseRunner.get_target_spec(filename, line)
  _, _ = filename, line --- yeah, I hate warnings :)
  error('get_target_spec must be implemented by the runner')
end

return BaseRunner
