local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local helpers = require('tests.helpers')
local runner = helpers.runner

T['is_valid_starting_spec_block'] = MiniTest.new_set()

T['is_valid_starting_spec_block']['recognizes a configured starter'] = function()
  eq(runner:is_valid_starting_spec_block('describe("example")', 2), true)
end

T['is_valid_starting_spec_block']['ignores non-starters'] = function()
  eq(runner:is_valid_starting_spec_block('local value = 1', 2), false)
end

T['is_valid_starting_spec_block']['rejects a starter at the same indentation'] = function()
  eq(runner:is_valid_starting_spec_block('  it("example")', 3), false)
end

T['is_valid_starting_spec_block']['accepts a starter with shallower indentation'] = function()
  eq(runner:is_valid_starting_spec_block('  it("example")', 5), true)
end

return T
