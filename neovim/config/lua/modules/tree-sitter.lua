-- {{{ Installation

vim.cmd('packadd! nvim-treesitter')

-- }}}

-- Configuration {{{

-- Supported languages:
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local languages = {
  'bash',
  'css',
  'html',
  'javascript',
  'json',
  -- 'ledger',
  'lua',
  'ocaml',
  'php',
  'rust',
  'toml',
  'tsx',
  'typescript',
}

local highlight = {
  enable = true,
}

local indent = {
  enable = true,
}

local incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<a-v>',
    node_incremental = '<a-v>',
    node_decremental = '<a-V>',
  },
}

-- }}}

-- {{{ Initialization

require('nvim-treesitter.configs').setup({
  ensure_installed = languages,
  highlight,
  indent,
  incremental_selection,
})

-- }}}

-- vim:foldmethod=marker
