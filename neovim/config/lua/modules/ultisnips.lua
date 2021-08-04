vim.cmd('packadd! ultisnips')

vim.g['UltiSnipsExpandTrigger'] = '<m-cr>'
vim.g['UltiSnipsJumpForwardTrigger'] = '<cr>'

vim.api.nvim_set_keymap('n', '<a-s>', ':UltiSnipsEdit<cr>', {noremap = true, silent = true})
