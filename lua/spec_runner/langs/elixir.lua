local BaseRunner = require('spec_runner.langs.base')

---@class ElixirRunner: Runner
local Elixir = setmetatable({
  lang = 'elixir',
  test_block_starters = { 'describe', 'it' },
}, {
  __index = BaseRunner,
})

function Elixir:get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Elixir
