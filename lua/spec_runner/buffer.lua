
M = {}

function M.append_output(buf, output)
  vim.schedule(function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    for line in output:gmatch('([^\r\n]+)') do
      table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end)
end

function M.open_output_buffer()
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

return M

