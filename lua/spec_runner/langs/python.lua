local BaseRunner = require('spec_runner.langs.base')
local utils = require('spec_runner.utils')

---@class PythonRunner: Runner
local Python = setmetatable({
  lang = 'python'
}, {
  __index = BaseRunner
})

local function token_name(line, token_type)
  return line:match('^' .. token_type .. '%s+([%w_]+)')
end

function Python:get_current_cursor_spec_starting_line()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  local class_name = nil
  local function_name = nil
  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line >= 0 do
    local line_content = vim.api.nvim_buf_get_lines(buf, start_line, start_line + 1, false)[1]
    local stripped_line = utils.strip(line_content)

    first_code_line_tab_index = self:tab_index(line_content, first_code_line_tab_index, is_first_line)

    if self:is_valid_starting_spec_block(line_content) then
      local current_line_tab_index = string.find(line_content, '%S')

      if first_code_line_tab_index ~= nil and current_line_tab_index < first_code_line_tab_index then
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
  end

  if function_name ~= nil then
    target = target .. '.' .. function_name
  end

  return target
end

function Python:get_target_spec(_, target_spec)
  return target_spec
end

function Python:is_valid_starting_spec_block(line_content)
  local stripped_line_content = utils.strip(line_content)

  return utils.starts_with(stripped_line_content, 'def test_') or (
    utils.starts_with(stripped_line_content, 'class ')
    and utils.contains(stripped_line_content, 'Test')
  )
end

return Python
