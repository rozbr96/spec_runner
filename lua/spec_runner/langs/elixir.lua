local Base = require('spec_runner.langs.base')

Elixir = {}

function Elixir.get_current_cursor_spec_starting_line()
  return Base.get_current_cursor_starting_line({ 'describe ', 'test ' })
end

function Elixir.get_target_spec(filename, line)
  return filename .. ':' .. line
end

return Elixir
