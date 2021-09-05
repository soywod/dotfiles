--- Emmet module.
-- Module for expanding CSS/HTML abbreviations.
-- https://github.com/mattn/emmet-vim
-- @module pkgs.emmet
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! emmet-vim')

vim.g['user_emmet_install_global'] = 0
vim.g['user_emmet_mode'] = 'i'
vim.g['user_emmet_leader_key'] = ','

vim.api.nvim_exec([[
  augroup emmet
    autocmd! * <buffer>
    autocmd FileType html,typescriptreact,css,scss EmmetInstall
  augroup END
]], false)
