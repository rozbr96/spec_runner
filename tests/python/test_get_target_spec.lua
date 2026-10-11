local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Python = require('spec_runner.langs.python')

T['returns the target spec unchanged'] = function()
  eq(
    Python:get_target_spec('ignored.py', 'test_module.TestExample.test_case'),
    'test_module.TestExample.test_case'
  )
end

T['supports an empty target spec'] = function()
  eq(Python:get_target_spec('ignored.py', ''), '')
end

return T
