
local buffer = require('spec_runner.buffer')
local system = require('spec_runner.system')
local langs = require('spec_runner.langs')

M = {}

function M.run_specs()
  local command
  local filetype = vim.bo.filetype

  if filetype == 'ruby' then
    command = langs.get_ruby_spec_command()
  else
    if filetype == '' then
      filetype = 'Unknown language!'
    end

    command = {
      cmd = 'echo',
      args = { 'Unsupported filetype: ' .. filetype }
    }
  end

  local buf = buffer.open_output_buffer()
  system.run_shell_command(buf, command)
end


return M

