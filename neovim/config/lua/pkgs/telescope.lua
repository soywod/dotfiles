--- Telescope module.
-- Module for fuzzy finding eveything.
-- https://github.com/nvim-telescope/telescope.nvim
-- @module pkgs.telescope
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! plenary.nvim')
vim.cmd('packadd! popup.nvim')
vim.cmd('packadd! telescope.nvim')

local telescope = require('telescope')
local actions = require('telescope.actions')
local fp = require('utils.fp')

--- Telescope pickers mapping table.
-- Mapping table where:
-- * the key is a telescope.builtin picker name
-- * the value is a table where:
--   * the first item is the binding key (used with ALT)
--   * the rest are options passed to the telescope.builtin function
-- @table mappings
local mappings = {
  find_files = {'f', previewer = false}, -- find file picker
  file_browser = {'F', previewer = false}, -- browse file picker
  oldfiles = {'o', previewer = false}, -- old file picker
  live_grep = {'g', previewer = false}, -- grep picker
  buffers = {'b', previewer = false}, -- buffer picker
  lsp_document_diagnostics = {'d', previewer = false}, -- LSP document diagnostic picker
  lsp_workspace_diagnostics = {'D', previewer = false}, -- LSP workspace diagnostic picker
  lsp_document_symbols = {'w', previewer = false}, -- LSP document symbol picker
  lsp_workspace_symbols = {'W', previewer = false}, -- LSP workspace symbol picker
  lsp_references = {'r', previewer = false}, -- LSP reference picker
  lsp_code_actions = {'c', previewer = false}, -- LSP code action picker
}

telescope.setup({
  defaults = {
    -- Replace default rounded corners by square ones
    borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
    mappings = {
      i = {
        -- Disable the normal mode for all popups
        ['<esc>'] = actions.close,
        -- Move selected items to the quickfix list
        ['<a-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = fp.map(function(picker, picker_opts)
    local key = '<a-'..table.remove(picker_opts, 1)..'>'
    local cmd = ':Telescope '..picker..'<cr>'
    local opts = {noremap = true, silent = true}
    vim.api.nvim_set_keymap('n', key, cmd, opts)
    return picker_opts
  end, mappings),
})
