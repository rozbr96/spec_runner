
local spec_runner = {}

local function open_output_buffer()
  local buf = vim.api.nvim_create_buf(true, true)

  vim.bo[buf].buftype = 'nofile'

  local width = 160
  local height = 40
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'single'
  })

  return buf, win
end

local function run_shell_command(cmd, buf)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Error: ' .. table.concat(output, '\n') })
  else
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  end
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
  local command
  local filetype = vim.bo.filetype
  local buf = open_output_buffer()

  if filetype == 'ruby' then
    command = get_ruby_spec_command()
  else
    command = "echo 'Unsupported filetype: " .. filetype .. "'"
  end

  run_shell_command(command, buf)
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

