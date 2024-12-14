
local defaults = require('spec_runner.defaults')
local commands = require('spec_runner.commands')

local M = {}

function M.setup(user_config)
  defaults.config = vim.tbl_deep_extend('force', defaults.config, user_config or {})

  vim.api.nvim_create_user_command(
    'RunSpecs',
    function()
      commands.run_specs()
    end,
    { desc = 'Run specs for the current project' }
  )
end

return M

