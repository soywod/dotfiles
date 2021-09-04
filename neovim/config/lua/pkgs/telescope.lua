--- Telescope module.
-- Telescope is a fuzzy finder over lists.
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
-- @field find_files find files picker
-- @field file_browser browse files picker
-- @field oldfiles old files picker
-- @field live_grep grep picker
-- @field buffers buffers picker
-- @field lsp_document_diagnostics LSP document diagnostics picker
-- @field lsp_workspace_diagnostics LSP workspace diagnostics picker
-- @field lsp_document_symbols LSP document symbols picker
-- @field lsp_workspace_symbols LSP workspace symbols picker
-- @field lsp_references LSP references picker
-- @field lsp_code_actions LSP code actions picker
local mappings = {
  find_files = {'f', previewer = false},
  file_browser = {'F', previewer = false},
  oldfiles = {'h', previewer = false},
  live_grep = {'g', previewer = false},
  buffers = {'b', previewer = false},
  lsp_document_diagnostics = {'d', previewer = false},
  lsp_workspace_diagnostics = {'D', previewer = false},
  lsp_document_symbols = {'w', previewer = false},
  lsp_workspace_symbols = {'W', previewer = false},
  lsp_references = {'r', previewer = false},
  lsp_code_actions = {'c', previewer = false},
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
