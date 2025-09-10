
local utils = require('spec_runner.utils')
local configs = require('spec_runner.configs')

M = {}

M.ruby = require('spec_runner.langs.ruby')
M.python = require('spec_runner.langs.python')
M.elixir = require('spec_runner.langs.elixir')

function M.get_spec_command(lang, file, target_spec)
  file = file or vim.fn.expand('%')
  local lang_configs = configs.config[lang]
  local full_command = lang_configs.cmd .. ' ' .. table.concat(lang_configs.args, ' ')
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

