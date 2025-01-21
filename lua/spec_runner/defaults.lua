
M = {}

M.config = {
  ruby = {
    cmd = 'rspec',
    args = {}
  },
  python = {
    cmd = 'python',
    args = { '-m', 'unittest', '--verbose' }
  }
}

return M

