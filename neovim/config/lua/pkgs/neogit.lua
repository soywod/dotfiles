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

local map_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<a-G>', ":Neogit<cr>", map_opts)
