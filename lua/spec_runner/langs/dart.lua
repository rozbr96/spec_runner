local BaseRunner = require('spec_runner.langs.base')
local utils = require('spec_runner.utils')

---@class DartRunner: Runner
local Dart = setmetatable({
  lang = 'dart'
}, {
  __index = BaseRunner
})

---@param line_content string
---@return string[]?
local function get_test_block_name_regexes(line_content)
  if utils.starts_with(line_content, 'test(') then
    return { [[test%(r?('.*')]], [[test%(r?(".*")]] }
  elseif utils.starts_with(line_content, 'testWidgets(') then
    return { [[testWidgets%(r?('.*')]], [[testWidgets%(r?(".*")]] }
  elseif utils.starts_with(line_content, 'group(') then
    return { [[group%(r?('.*')]], [[group%(r?(".*")]] }
  elseif utils.starts_with(line_content, 'void main()') then
    return { '^$' }
  end

  return nil
end

---@return string
function Dart:get_current_cursor_spec_starting_line()
  local buffer = vim.api.nvim_get_current_buf()
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)

  ---@type integer?
  local first_code_line_tab_index
  local is_first_line = true
  local start_line = cursor[1] - 1

  while start_line > 0 do
    local line_content = vim.api.nvim_buf_get_lines(buffer, start_line, start_line + 1, false)[1]

    first_code_line_tab_index = self:tab_index(
      line_content,
      first_code_line_tab_index,
      is_first_line
    )

    local stripped_line_content = utils.strip(line_content)
    local regexes = get_test_block_name_regexes(stripped_line_content)

    if regexes ~= nil then
      local current_line_tab_index = string.find(line_content, '%S')

      if current_line_tab_index
          and first_code_line_tab_index
          and current_line_tab_index < first_code_line_tab_index
      then
        if regexes[1] == '^$' then
          return ''
        end

        for _, regex in ipairs(regexes) do
          local block_name = stripped_line_content:match(regex)

          if block_name then
            return ' --name ' .. block_name
          end
        end
      end
    end

    start_line = start_line - 1
    is_first_line = false
  end

  return ''
end

---@param filename string
---@param block_name_arg string
---@return string
function Dart:get_target_spec(filename, block_name_arg)
  return filename .. block_name_arg
end

return Dart
