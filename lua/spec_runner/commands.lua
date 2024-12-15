
local last_command
local buffer = require('spec_runner.buffer')
local system = require('spec_runner.system')
local langs = require('spec_runner.langs')

local function run(command)
  last_command = command

  local buf = buffer.open_output_buffer()
  system.run_shell_command(buf, command)
end

local function unsupported_lang_command(filetype)
  if filetype == '' then
    filetype = 'Unknown language!'
  end

  return {
    cmd = 'echo',
    args = { 'Unsupported filetype: ' .. filetype }
  }
end


M = {}

function M.run_specs()
  local command
  local filetype = vim.bo.filetype

  if filetype == 'ruby' then
    command = langs.get_spec_command('ruby')
  else
    command = unsupported_lang_command(filetype)
  end

  run(command)
end

function M.run_current_spec()
  local command
  local file = vim.fn.expand('%')
  local filetype = vim.bo.filetype

  if filetype == 'ruby' then
    local spec_line = langs.ruby.get_current_cursor_spec_starting_line()
    local target_spec = langs.ruby.get_target_spec(file, spec_line)
    command = langs.get_spec_command('ruby', file, target_spec)
  else
    command = unsupported_lang_command(filetype)
  end

  run(command)
end

function M.run_last_command()
  if last_command then
    run(last_command)
  end
end

return M

