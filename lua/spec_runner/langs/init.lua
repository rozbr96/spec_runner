
local utils = require('spec_runner.utils')
local default_configs = require('spec_runner.defaults')

M = {}

M.ruby = require('spec_runner.langs.ruby')

function M.get_spec_command(lang, file, target_spec)
  file = file or vim.fn.expand('%')
  local configs = default_configs.config[lang]
  local full_command = configs.cmd .. ' ' .. table.concat(configs.args, ' ')
  local parts = utils.split(full_command, ' ')

  local command = {
    cmd = table.remove(parts, 1),
    args = parts
  }

  if vim.fn.filereadable(file) == 1 then
    table.insert(command.args, target_spec or file)
  end

  return command
end

return M

