--- Icons module.
-- Module for icons management.
-- https://github.com/kyazdani42/nvim-web-devicons
-- @module pkgs.icons
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! nvim-web-devicons')

local icons = require('nvim-web-devicons')

icons.setup({default = true})
