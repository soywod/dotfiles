vim.cmd('packadd! nvim-compe')

require('compe').setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'disable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    ultisnips = true,
  },
})

vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("\\<cr>")', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<tab>', 'pumvisible() ? "\\<c-n>" : "\\<tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "<s-tab>"', {noremap = true, silent = true, expr = true})

-- vim:foldmethod=marker
