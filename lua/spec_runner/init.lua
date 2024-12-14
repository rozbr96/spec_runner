
local spec_runner = {}

local function append_output(buf, output)
  vim.schedule(function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for line in output:gmatch('([^\r\n]+)') do
      table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end)
end

local function open_output_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

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

local function run_shell_command(buf, command)
  local pid
  local stdin = vim.loop.new_pipe(true)
  local stdout = vim.loop.new_pipe(true)
  local stderr = vim.loop.new_pipe(true)

  pid, _ = vim.loop.spawn(command.cmd, {
    args = command.args,
    env = command.env,
    stdio = { stdin, stdout, stderr },
    close_fd = { stdin = true,  stdout = true,  stderr = true }
  })

  if not pid then
    append_output(buf, 'Failed...')
    append_output(buf, 'Command: ' .. command.cmd)

    if command.args then
      append_output(buf, 'Args: ')
      for i = 1, #command.args do
        append_output(buf, '\t' .. command.args[i])
      end
    end

    if command.env then
      append_output(buf, 'Env: ')
      for i = 1, #command.env do
        append_output(buf, '\t' .. command.env[i])
      end
    end

    return
  end

  vim.loop.read_start(stdout, function(err, data)
    if err then
      append_output(buf, 'Erro reading stdout: ' .. err)
    elseif data then
      append_output(buf, data)
    end
  end)

  vim.loop.read_start(stderr, function(err, data)
    if err then
      append_output(buf, 'Error reading stderr: ' .. err)
    elseif data then
      append_output(buf, data)
    end
  end)
end

local function get_ruby_spec_command()
  local command = { cmd = 'rspec' }
  local file = vim.fn.expand('%')

  if vim.fn.filereadable(file) == 1 then
    command.args = { file }
  end

  return command
end

function spec_runner.run_specs()
  local command
  local filetype = vim.bo.filetype

  if filetype == 'ruby' then
    command = get_ruby_spec_command()
  else
    if filetype == '' then
      filetype = 'Unknown language!'
    end

    command = {
      cmd = 'echo',
      args = { 'Unsupported filetype: ' .. filetype }
    }
  end

  local buf = open_output_buffer()
  run_shell_command(buf, command)
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

