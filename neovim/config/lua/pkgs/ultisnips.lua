--- UltiSnips module.
--- Module for expanding UltiSnips snippets.
-- https://github.com/SirVer/ultisnips
-- @module pkgs.ultisnips
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! ultisnips')

vim.g['UltiSnipsExpandTrigger'] = '<noop>'
vim.g['UltiSnipsJumpBackwardTrigger'] = '<noop>'
vim.g['UltiSnipsJumpForwardTrigger'] = '<noop>'
vim.g['UltiSnipsEditSplit'] = 'vertical'

vim.api.nvim_set_keymap('n', '<a-s>', ':UltiSnipsEdit<cr>', {noremap = true, silent = true})
