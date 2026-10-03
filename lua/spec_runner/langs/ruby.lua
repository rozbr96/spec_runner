local BaseRunner = require('spec_runner.langs.base')

---@class RubyRunner: Runner
local Ruby = setmetatable({
  lang = 'ruby',
  test_block_starters = { 'it ', 'context ', 'describe ', 'RSpec.describe ' }
}, {
  __index = BaseRunner
})

function Ruby:get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Ruby
