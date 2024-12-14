
local defaults = require('spec_runner.defaults')
local commands = require('spec_runner.commands')

local function get_custom_config()
  local config_file = vim.fn.getcwd() .. '/.spec_runner_config.lua'

  if vim.fn.filereadable(config_file) == 1 then
    local ok, result = pcall(dofile, config_file)

    if ok and type(result) == 'table' then
      return result
    end
  end

  return {}
end

local M = {}

function M.setup(user_config)
  local custom_config = get_custom_config()
  defaults.config = vim.tbl_deep_extend('force', defaults.config, user_config or {}, custom_config)

  vim.api.nvim_create_user_command(
    'RunSpecs',
    function()
      commands.run_specs()
    end,
    { desc = 'Run specs for the current project' }
  )

  vim.api.nvim_create_user_command(
    'RunCurrentSpec',
    function()
      commands.run_current_spec()
    end,
    { desc = 'Run spec for the current cursor position' }
  )
end

return M

