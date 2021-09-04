vim.cmd('packadd! emmet-vim')

vim.g['user_emmet_install_global'] = 0
vim.g['user_emmet_mode'] = 'i'
vim.g['user_emmet_leader_key'] = ','

vim.api.nvim_exec([[
  augroup emmet
    autocmd FileType html,typescriptreact,css,scss EmmetInstall
  augroup END
]], false)
