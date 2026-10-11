local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local helpers = require('tests.helpers')
local runner = helpers.runner

T['get_current_cursor_spec_starting_line'] = MiniTest.new_set()

T['get_current_cursor_spec_starting_line']['finds the nearest enclosing block'] = function()
  helpers.with_buffer({
    'describe("outer")',
    '  it("inner")',
    '    assert(true)',
  }, { 3, 0 }, function()
    eq(runner:get_current_cursor_spec_starting_line(), 2)
  end)
end

T['get_current_cursor_spec_starting_line']['falls back to line one when no block exists'] = function()
  helpers.with_buffer({
    'local value = 1',
    'print(value)',
  }, { 2, 0 }, function()
    eq(runner:get_current_cursor_spec_starting_line(), 1)
  end)
end

return T
