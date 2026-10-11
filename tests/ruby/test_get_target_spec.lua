local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Ruby = require('spec_runner.langs.ruby')

T['returns the filename and line number'] = function()
  eq(
    Ruby:get_target_spec('spec/models/user_spec.rb', 12),
    'spec/models/user_spec.rb:12'
  )
end

T['supports line numbers passed as strings'] = function()
  eq(
    Ruby:get_target_spec('spec/models/user_spec.rb', '42'),
    'spec/models/user_spec.rb:42'
  )
end

return T
