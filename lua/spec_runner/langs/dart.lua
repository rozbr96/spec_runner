local utils = require('spec_runner.utils')

Dart = {}

function Dart.get_current_cursor_spec_starting_line()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)

  local is_first_line = true
  local first_code_line_tab_index = nil
  local start_line = cursor[1] - 1

  while start_line > 0 do
    local test_block_name_regexes = nil
    local line = vim.api.nvim_buf_get_lines(buf, start_line, start_line + 1, false)[1]
    local stripped_line = utils.strip(line)

    if first_code_line_tab_index == nil and stripped_line ~= '' then
      first_code_line_tab_index = string.find(line, '%S')
      first_code_line_tab_index = (first_code_line_tab_index or 0) + (is_first_line and 1 or 0)
    end

    if utils.starts_with(stripped_line, 'test(') then
      test_block_name_regexes = { [[test%(r?('.*')]], [[test%(r?(".*")]] }
    elseif utils.starts_with(stripped_line, 'testWidgets(') then
      test_block_name_regexes = { [[testWidgets%(r?('.*')]], [[testWidgets%(r?(".*")]] }
    elseif utils.starts_with(stripped_line, 'group(') then
      test_block_name_regexes = { [[group%(r?('.*')]], [[group%(r?(".*")]] }
    elseif utils.starts_with(stripped_line, 'void main()') then
      test_block_name_regexes = { '^$' }
    end

    if test_block_name_regexes ~= nil then
      local current_line_tab_index = string.find(line, '%S')

      if current_line_tab_index < first_code_line_tab_index then
        if test_block_name_regexes[1] == '^$' then
          return ''
        end

        for _, test_block_name_regex in pairs(test_block_name_regexes) do
          local block_name = stripped_line:match(test_block_name_regex)

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

function Dart.get_target_spec(filename, block_name_arg)
  return filename .. block_name_arg
end

return Dart
