
return {
  ruby = {
    cmd = 'docker',
    args = { 'compose', 'exec', '<service_name>', 'rspec', '-f d' }
  }
}

