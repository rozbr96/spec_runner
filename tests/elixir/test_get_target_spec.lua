local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Elixir = require('spec_runner.langs.elixir')

T['returns the filename and line number'] = function()
  eq(
    Elixir:get_target_spec('test/example_test.exs', 12),
    'test/example_test.exs:12'
  )
end

T['supports line numbers passed as strings'] = function()
  eq(
    Elixir:get_target_spec('test/example_test.exs', '42'),
    'test/example_test.exs:42'
  )
end

return T
