M = {}

---@type table<string, Runner.Command>
M.config = {
  ruby = {
    cmd = 'rspec',
    args = {}
  },
  python = {
    cmd = 'python',
    args = { '-m', 'unittest', '--verbose' }
  },
  elixir = {
    cmd = 'mix',
    args = { 'test' },
    failed_specs_args = { '--failed' },
    stop_at_first_failure_args = { '--max-failures', '1' }
  },
  dart = {
    cmd = 'flutter',
    args = { 'test' },
    stop_at_first_failure_args = { '--fail-fast' }
  }
}

return M
