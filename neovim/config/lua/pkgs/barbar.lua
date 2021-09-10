--- Barbar module.
-- Module for better buffer and tab management.
-- https://github.com/romgrk/barbar.nvim
-- @module pkgs.barbar
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! barbar.nvim')

vim.g.bufferline = {
  -- Disable animations
  animation = false,

  -- Disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Disable current/total tabpages indicator (top right corner)
  tabpages = false,

  -- Disable close button
  closable = false,

  -- Disable clickable tabs
  clickable = false,

  -- Disable icons
  icons = false,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = true,

  -- Configure icons on the bufferline.
  icon_separator_active = '➜ ',
  icon_separator_inactive = '  ',
  icon_close_tab = '',
  icon_close_tab_modified = '',
  icon_pinned = '',

  -- If true, new buffers will be inserted at the end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = true,

  -- Set the maximum padding width with which to surround each tab
  maximum_padding = 0,

  -- Set the maximum buffer name length.
  maximum_length = 100,
}

local mappings = {
  {key = 'h', cmd = 'Previous'},
  {key = 'l', cmd = 'Next'},
  {key = 'H', cmd = 'MovePrevious'},
  {key = 'L', cmd = 'MoveNext'},
  {key = '1', cmd = 'Goto 1'},
  {key = '2', cmd = 'Goto 2'},
  {key = '3', cmd = 'Goto 3'},
  {key = '4', cmd = 'Goto 4'},
  {key = '5', cmd = 'Goto 5'},
  {key = '6', cmd = 'Goto 6'},
  {key = '7', cmd = 'Goto 7'},
  {key = '8', cmd = 'Goto 8'},
  {key = '9', cmd = 'Goto 9'},
  {key = '0', cmd = 'GotoLast'},
}

local map_opts = {noremap = true, silent = true}
for _, mapping in ipairs(mappings) do
  local key = '<a-'..mapping.key..'>'
  local cmd = ':Buffer'..mapping.cmd..'<cr>'
  vim.api.nvim_set_keymap('n', key, cmd, map_opts)
end
