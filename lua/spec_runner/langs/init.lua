
local utils = require('spec_runner.utils')
local default_configs = require('spec_runner.defaults')

M = {}

function M.get_ruby_spec_command()
  local file = vim.fn.expand('%')
  local ruby_configs = default_configs.config.ruby
  local full_command = ruby_configs.cmd .. ' ' .. table.concat(ruby_configs.args, ' ')
  local parts = utils.split(full_command, ' ')

  local command = {
    cmd = table.remove(parts, 1),
    args = parts
  }

  if vim.fn.filereadable(file) == 1 then
    table.insert(command.args, file)
  end

  return command
end

return M

