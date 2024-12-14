
local spec_runner = {}

local function run_shell_command(cmd)
  local output = vim.fn.system(cmd)
  print(output)
end

function spec_runner.run_specs()
  local default_command = "echo 'Running specs...'"
  run_shell_command(default_command)
end

function spec_runner.setup()
  vim.api.nvim_create_user_command(
    'RunSpecs',
    function()
      spec_runner.run_specs()
    end,
    { desc = 'Run specs for the current project' }
  )
end

return spec_runner

