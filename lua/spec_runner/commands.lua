local last_buf
local last_command
local buffer = require('spec_runner.buffer')
local langs = require('spec_runner.langs')
local configs = require('spec_runner.configs')

---Spawns command `command`
---
---@param command Runner.Command
local function run(command)
  last_command = command

  last_buf, _ = buffer.open_output_buffer()

  vim.fn.jobstart(
    vim.list_extend({ command.cmd }, command.args or {}),
    { term = true }
  )
end

---Builds command to indicate that specified language is unsupported
---
---@param filetype string The language which is not supported
---@return Runner.Command
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

---Runs all specs for the current file
---
---@param only_failed_tests boolean? Indicates if only previous failed specs are to be tested
---@param stop_at_first_failure boolean? Indicates if runner should stop at first failured
function M.run_specs(only_failed_tests, stop_at_first_failure)
  local command
  local filetype = vim.bo.filetype
  local lang = langs[filetype]

  if lang then
    local lang_configs = configs.config[filetype]

    command = lang:get_spec_command()

    if only_failed_tests then
      if lang_configs.failed_specs_flag then
        table.insert(command.args, lang_configs.failed_specs_flag)
      end
    end

    if stop_at_first_failure then
      if lang_configs.stop_at_first_failure_flag then
        table.insert(command.args, lang_configs.stop_at_first_failure_flag)
      end
    end
  else
    command = unsupported_lang_command(filetype)
  end

  run(command)
end

---Runs the spec block within the current cursor position
function M.run_current_spec()
  local command
  local file = vim.fn.expand('%')
  local filetype = vim.bo.filetype

  if langs[filetype] then
    local spec_line = langs[filetype]:get_current_cursor_spec_starting_line()
    local target_spec = langs[filetype]:get_target_spec(file, spec_line)
    command = langs[filetype]:get_spec_command(file, target_spec)
  else
    command = unsupported_lang_command(filetype)
  end

  run(command)
end

---Runs the last successfull spec command
function M.run_last_command()
  if last_command then
    run(last_command)
  end
end

---Runs the previous failed specs
function M.run_failed_specs()
  M.run_specs(true)
end

---Runs specs and stops at first failure
function M.run_till_first_failure()
  M.run_specs(false, true)
end

---Runs previous failed specs and stops at first failure
function M.run_failed_specs_till_first_failure()
  M.run_specs(true, true)
end

---Displays last command output
function M.display_last_output()
  if last_buf and vim.api.nvim_buf_is_loaded(last_buf) then
    buffer.open_output_buffer(last_buf)
  end
end

return M
