vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:prepend(vim.fn.getcwd() .. '/deps/mini.nvim')

require('mini.test').setup()
