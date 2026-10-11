local T = MiniTest.new_set()
local eq = MiniTest.expect.equality
local utils = require('spec_runner.utils')

T['split()'] = MiniTest.new_set()

T['split()']['splits a string by delimiter'] = function()
  eq(utils.split('mix test --failed', ' '), {
    'mix',
    'test',
    '--failed',
  })
end

T['split()']['preserves empty fields between delimiters'] = function()
  eq(utils.split('one::three', ':'), {
    'one',
    '',
    'three',
  })
end

T['strip()'] = MiniTest.new_set()

T['strip()']['removes leading and trailing whitespace'] = function()
  eq(utils.strip('  hello world  '), 'hello world')
end

T['starts_with()'] = MiniTest.new_set()

T['starts_with()']['matches a literal prefix'] = function()
  eq(utils.starts_with('test.foo', 'test.'), true)
end

T['contains()'] = MiniTest.new_set()

T['contains()']['matches Lua patterns'] = function()
  eq(utils.contains('testWidgets(', 'test%u'), true)
end

return T
