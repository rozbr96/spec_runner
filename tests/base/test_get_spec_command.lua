local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local helpers = require('tests.helpers')

T['get_spec_command'] = MiniTest.new_set()

T['get_spec_command']['builds the command and appends the target file'] = function()
  local file = vim.fn.tempname()
  vim.fn.writefile({ 'test' }, file)

  helpers.with_config('__test__', {
    cmd = 'example-runner',
    args = { 'test', '--verbose' },
  }, function()
    local result = helpers.runner:get_spec_command(file)

    eq(result, {
      cmd = 'example-runner',
      args = { 'test', '--verbose', file },
    })
  end)

  vim.fn.delete(file)
end

T['get_spec_command']['uses the explicit target spec'] = function()
  local file = vim.fn.tempname()
  vim.fn.writefile({ 'test' }, file)

  helpers.with_config('__test__', {
    cmd = 'example-runner',
    args = { 'test' },
  }, function()
    local result = helpers.runner:get_spec_command(file, file .. ':12')

    eq(result.args, { 'test', file .. ':12' })
  end)

  vim.fn.delete(file)
end

T['get_spec_command']['does not append a nonexistent file'] = function()
  local file = vim.fn.tempname()

  helpers.with_config('__test__', {
    cmd = 'example-runner',
    args = { 'test' },
  }, function()
    eq(helpers.runner:get_spec_command(file), {
      cmd = 'example-runner',
      args = { 'test' },
    })
  end)
end

return T
