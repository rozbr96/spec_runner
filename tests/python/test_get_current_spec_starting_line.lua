local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Python = require('spec_runner.langs.python')
local with_buffer = require('tests.helpers').with_buffer

local function with_python_file(lines, cursor, callback)
  local original_name = vim.api.nvim_buf_get_name(0)

  with_buffer(lines, cursor, function()
    vim.api.nvim_buf_set_name(0, 'tmp/test_example.py')
    callback()
    vim.api.nvim_buf_set_name(0, original_name)
  end)
end

T['function targets'] = MiniTest.new_set()

T['function targets']['returns the test function name'] = function()
  with_python_file({
    'def test_adds_numbers():',
    '    assert 1 + 1 == 2',
  }, { 2, 4 }, function()
    eq(Python:get_current_cursor_spec_starting_line(), 'tmp.test_example.test_adds_numbers')
  end)
end

T['class targets'] = MiniTest.new_set()

T['class targets']['returns the class and test method names'] = function()
  with_python_file({
    'class TestCalculator:',
    '    def test_adds_numbers(self):',
    '        assert 1 + 1 == 2',
  }, { 3, 8 }, function()
    eq(
      Python:get_current_cursor_spec_starting_line(),
      'tmp.test_example.TestCalculator.test_adds_numbers'
    )
  end)
end

T['class targets']['returns the class name outside a test method'] = function()
  with_python_file({
    'class TestCalculator:',
    '    def helper(self):',
    '        pass',
  }, { 3, 8 }, function()
    eq(Python:get_current_cursor_spec_starting_line(), 'tmp.test_example.TestCalculator')
  end)
end

T['fallback'] = MiniTest.new_set()

T['fallback']['returns the module path when no test block is found'] = function()
  with_python_file({
    'def helper():',
    '    return 42',
  }, { 2, 4 }, function()
    eq(Python:get_current_cursor_spec_starting_line(), 'tmp.test_example')
  end)
end

return T
