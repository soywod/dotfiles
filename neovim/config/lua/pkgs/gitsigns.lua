--- Gitsigns module.
-- Module for better git signs.
-- https://github.com/lewis6991/gitsigns.nvim
-- @module pkgs.gitsigns
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! gitsigns.nvim')

local gitsigns = require('gitsigns')

gitsigns.setup()
