
local spec_runner = {}

local function run_shell_command(cmd)
  local output = vim.fn.system(cmd)
  print(output)
end

local function get_ruby_spec_command()
  local file = vim.fn.expand('%')
  if vim.fn.filereadable(file) == 1 then
    return 'rspec ' .. file
  else
    return "echo 'Open a file first, dumbass'"
  end
end

function spec_runner.run_specs()
  local filetype = vim.bo.filetype
  local command

  if filetype == 'ruby' then
    command = get_ruby_spec_command()
  else
    command = "echo 'Unsupported filetype: " .. filetype .. "'"
  end

  run_shell_command(command)
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

