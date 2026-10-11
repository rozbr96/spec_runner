local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Dart = require('spec_runner.langs.dart')

T['concatenates the filename and block name argument'] = function()
  eq(
    Dart:get_target_spec('test/widget_test.dart', ' --name "renders correctly"'),
    'test/widget_test.dart --name "renders correctly"'
  )
end

T['supports an empty block name argument'] = function()
  eq(
    Dart:get_target_spec('test/widget_test.dart', ''),
    'test/widget_test.dart'
  )
end

return T
