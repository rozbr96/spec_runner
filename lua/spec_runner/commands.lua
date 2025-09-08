local last_buf
local last_command
local buffer = require('spec_runner.buffer')
local langs = require('spec_runner.langs')

local function run(command)
  last_command = command

  last_buf, _ = buffer.open_output_buffer()

  vim.fn.termopen(command.cmd .. " " .. table.concat(command.args or {}, " "))
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

function M.run_specs(only_failed_tests)
  local command
  local filetype = vim.bo.filetype
  local lang = langs[filetype]

  if lang then
    command = langs.get_spec_command(filetype)

    if only_failed_tests then
      table.insert(command.args, lang.only_failed_specs_flag)
    end
  else
    command = unsupported_lang_command(filetype)
  end

  run(command)
end

function M.run_current_spec()
  local command
  local file = vim.fn.expand('%')
  local filetype = vim.bo.filetype

  if langs[filetype] then
    local spec_line = langs[filetype].get_current_cursor_spec_starting_line()
    local target_spec = langs[filetype].get_target_spec(file, spec_line)
    command = langs.get_spec_command(filetype, file, target_spec)
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

function M.run_failed_specs()
  M.run_specs(true)
end

function M.display_last_output()
  if last_buf and vim.api.nvim_buf_is_loaded(last_buf) then
    buffer.open_output_buffer(last_buf)
  end
end

return M
