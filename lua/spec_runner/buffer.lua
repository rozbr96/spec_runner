M = {}

---Opens a floating window with the given buffer content
---
---@param buf number? Existing buffer id (if none is given, creates a new one)
---@return number, number ids IDs for the buffer and window
function M.open_output_buffer(buf)
  buf = buf or vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  return buf, win
end

return M
