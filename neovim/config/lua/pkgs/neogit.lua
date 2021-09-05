--- Neogit module.
-- Module for managing git projects.
-- https://github.com/TimUntersberger/neogit
-- @module pkgs.neogit
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! plenary.nvim')
vim.cmd('packadd! neogit')

local neogit = require('neogit')

neogit.setup({
  signs = {
    section = {'+', '-'},
    item = {'+', '-'},
    hunk = {'', ''},
  },
  integrations = {
    diffview = true
  },
})
