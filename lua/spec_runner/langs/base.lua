local utils = require('spec_runner.utils')
local configs = require('spec_runner.configs')

---BaseRunner spec runner
---@class Runner
local BaseRunner = {}

---BaseRunner spec command
---@class Runner.Command
---@field cmd string
---@field args string[]
---@field failed_specs_flag string?
---@field stop_at_first_failure_flag string?

---The language code definition
---@type string
BaseRunner.lang = nil

---The block spec starters for the runner
---
---Starting line contents which represent spec blocks, like "`RSpec.describe`" or "`def test_`"
---@type string[]
BaseRunner.test_block_starters = {}

---Returns the starting line number for the current spec block
---
---If the cursor current position is not within a spec block, then first line reference is returned
---@return number | string
function BaseRunner:get_current_cursor_spec_starting_line()
  local buffer = vim.api.nvim_get_current_buf()
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)

  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line >= 0 do
    local line_content = vim.api.nvim_buf_get_lines(buffer, start_line, start_line + 1, false)[1]

    first_code_line_tab_index = self:tab_index(line_content, first_code_line_tab_index, is_first_line)

    if self:is_valid_starting_spec_block(line_content, first_code_line_tab_index) then
      return start_line + 1
    end

    start_line = start_line - 1
    is_first_line = false
  end

  return 1
end

---Calculates line tab index
---
---@param line_content string The line content
---@param first_code_line_tab_index number? The tab index for the previous processed line
---@param is_first_line boolean? Indicates if `line_content` refers to the first line of the buffer
---@return number | nil tab_index
function BaseRunner:tab_index(line_content, first_code_line_tab_index, is_first_line)
  if first_code_line_tab_index == nil and line_content ~= '' then
    first_code_line_tab_index = string.find(line_content, '%S')

    if first_code_line_tab_index ~= nil then
      first_code_line_tab_index = first_code_line_tab_index + (is_first_line and 1 or 0)
    end
  end

  return first_code_line_tab_index
end

---Checks if `line_content` is valid as starting block spec
---
---@param line_content string The line content to be checked for starting block spec
---@param first_code_line_tab_index number? The tab index for the current cursor position
---@return boolean is_valid
function BaseRunner:is_valid_starting_spec_block(line_content, first_code_line_tab_index)
  local stripped_line_content = utils.strip(line_content)

  for index = 1, #self.test_block_starters do
    if utils.starts_with(stripped_line_content, self.test_block_starters[index]) then
      local current_line_tab_index = string.find(line_content, '%S')

      if first_code_line_tab_index ~= nil and current_line_tab_index < first_code_line_tab_index then
        return true
      end
    end
  end

  return false
end

---Retrieves the spec command for the runner
---
---@param file string? The filename which spec is about to run
---@param target_spec string? The target spec which is about to run
---@return Runner.Command
function BaseRunner:get_spec_command(file, target_spec)
  file = file or vim.fn.expand('%')

  local lang_configs = configs.config[self.lang]
  local full_command = lang_configs.cmd .. ' ' .. table.concat(lang_configs.args, ' ')
  local parts = utils.split(full_command, ' ')

  ---@type Runner.Command
  local command = {
    cmd = table.remove(parts, 1),
    args = parts
  }

  if vim.fn.filereadable(file) == 1 then
    table.insert(command.args, target_spec or file)
  end

  return command
end

---MUST BE IMPLEMENTED BY THE RUNNER
---
---Builds the full targetted spec identification, along with path and line number
---
---@param filename string The targeted spec file
---@param line string | number The targeted spec line number
---@return string
function BaseRunner:get_target_spec(filename, line)
  _, _ = filename, line --- yeah, I hate warnings :)
  error('get_target_spec must be implemented by the runner')
end

return BaseRunner
