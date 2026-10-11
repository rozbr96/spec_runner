local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local BaseRunner = require('spec_runner.langs.base')

T['get_target_spec'] = MiniTest.new_set()

T['get_target_spec']['raises an error when not implemented'] = function()
  local ok, err = pcall(BaseRunner.get_target_spec, BaseRunner, 'example.lua', 10)

  eq(ok, false)
  eq(err:match('get_target_spec must be implemented by the runner') ~= nil, true)
end

return T
