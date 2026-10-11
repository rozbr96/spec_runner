local BaseRunner = require('spec_runner.langs.base')

local M = {}

M.runner = setmetatable({
  lang = '__test__',
  test_block_starters = {
    'describe(',
    'it(',
  },
}, { __index = BaseRunner })

function M.with_buffer(lines, cursor, callback)
  local original_buf = vim.api.nvim_get_current_buf()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, cursor or { 1, 0 })

  local ok, result = xpcall(callback, debug.traceback)

  vim.api.nvim_win_set_buf(0, original_buf)
  vim.api.nvim_buf_delete(buf, { force = true })

  if not ok then
    error(result, 0)
  end

  return result
end

---Temporarily override a language configuration.
function M.with_config(lang, config, callback)
  local configs = require('spec_runner.configs')
  local original = configs.config[lang]

  configs.config[lang] = config

  local ok, result = xpcall(callback, debug.traceback)

  configs.config[lang] = original

  if not ok then
    error(result, 0)
  end

  return result
end

return M
