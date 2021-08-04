vim.cmd('packadd! popup.nvim')
vim.cmd('packadd! plenary.nvim')
vim.cmd('packadd! telescope.nvim')

local map_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<a-i>', "<cmd>lua require('telescope.builtin').lsp_implementation({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-f>', "<cmd>lua require('telescope.builtin').find_files({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-F>', "<cmd>lua require('telescope.builtin').file_browser({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-h>', "<cmd>lua require('telescope.builtin').oldfiles({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-g>', "<cmd>lua require('telescope.builtin').live_grep({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-b>', "<cmd>lua require('telescope.builtin').buffers({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-d>', "<cmd>lua require('telescope.builtin').lsp_document_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-D>', "<cmd>lua require('telescope.builtin').lsp_workspace_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-c>', "<cmd>lua require('telescope.builtin').lsp_code_actions({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-w>', "<cmd>lua require('telescope.builtin').lsp_document_symbols({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-W>', "<cmd>lua require('telescope.builtin').lsp_workspace_symbols({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-r>', "<cmd>lua require('telescope.builtin').lsp_references({previewer = false})<cr>", map_opts)

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = require('telescope.actions').close
      },
    },
    borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
  }
})

-- vim:foldmethod=marker
