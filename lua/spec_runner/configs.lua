M = {}

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
    failed_specs_flag = '--failed',
    stop_at_first_failure_flag = '--max-failures 1'
  }
}

return M
