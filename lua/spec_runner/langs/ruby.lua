
local Base = require('spec_runner.langs.base')

Ruby = {}

function Ruby.get_current_cursor_spec_starting_line()
  return Base.get_current_cursor_starting_line({'it ', 'context ', 'describe ', 'RSpec.describe '})
end

function Ruby.get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Ruby

