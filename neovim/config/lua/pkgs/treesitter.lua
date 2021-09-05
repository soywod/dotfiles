--- Tree sitter module.
-- Module for enabling tree sitter features.
-- https://github.com/tree-sitter/tree-sitter
-- @module pkgs.treesitter
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! nvim-treesitter')

require('nvim-treesitter.configs').setup({
  -- Supported languages:
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = {
    'bash',
    'css',
    'graphql',
    'html',
    'javascript',
    'json',
    'lua',
    'ocaml',
    'php',
    'rust',
    'toml',
    'tsx',
    'typescript',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<a-v>',
      node_incremental = '<a-v>',
      node_decremental = '<a-V>',
    },
  },
})

-- vim:foldmethod=marker
