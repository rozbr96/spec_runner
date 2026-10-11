local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local runner = require('tests.helpers').runner

T['returns the first non-whitespace column'] = function()
  eq(runner:tab_index('  describe("example")', nil, false), 3)
end

T['adds one for the first processed line'] = function()
  eq(runner:tab_index('  describe("example")', nil, true), 4)
end

T['preserves the index for blank lines'] = function()
  eq(runner:tab_index('', 4, false), 4)
end

T['returns nil for a blank line without an index'] = function()
  eq(runner:tab_index('', nil, false), nil)
end

return T
