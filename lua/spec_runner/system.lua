
local buffer = require('spec_runner.buffer')

M = {}

function M.run_shell_command(buf, command)
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
    buffer.append_output(buf, 'Failed...')
    buffer.append_output(buf, 'Command: ' .. command.cmd)

    if command.args then
      buffer.append_output(buf, 'Args: ')
      for i = 1, #command.args do
        buffer.append_output(buf, '\t' .. command.args[i])
      end
    end

    if command.env then
      buffer.append_output(buf, 'Env: ')
      for i = 1, #command.env do
        buffer.append_output(buf, '\t' .. command.env[i])
      end
    end

    return
  end

  vim.loop.read_start(stdout, function(err, data)
    if err then
      buffer.append_output(buf, 'Erro reading stdout: ' .. err)
    elseif data then
      buffer.append_output(buf, data)
    end
  end)

  vim.loop.read_start(stderr, function(err, data)
    if err then
      buffer.append_output(buf, 'Error reading stderr: ' .. err)
    elseif data then
      buffer.append_output(buf, data)
    end
  end)
end

return M

