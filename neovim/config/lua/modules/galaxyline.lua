-- {{{ Installation

vim.cmd('packadd! nvim-web-devicons') -- Patched icons
vim.cmd('packadd! galaxyline.nvim')   -- Status line

-- }}}

-- Configuration {{{

local devicons_opts = {
  default = true,
}

local short_line_list = {
  'NvimTree',
  'vista',
  'dbui',
  'packer',
}

local theme = {
  bg = '#21242b',
  fg = '#bbc2cf',
  fg_alt = '#5b6268',
  yellow = '#ecbe7b',
  cyan = '#46d9ff',
  green = '#98be65',
  orange = '#da8548',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ff6c6b'
}

local section = require('galaxyline').section
local cond = require('galaxyline.condition')

-- {{{ Left section

section.left[1] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = cond.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, theme.bg},
  },
}

section.left[2] = {
  FileName = {
    provider = 'FileName',
    condition = cond.buffer_not_empty,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.blue, theme.bg, 'bold'}
  }
}

section.left[3] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {theme.red, theme.bg}
  }
}
section.left[4] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {theme.yellow, theme.bg},
  }
}

section.left[5] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {theme.cyan, theme.bg},
  }
}

section.left[6] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {theme.blue, theme.bg},
  }
}

-- }}}

-- {{{ Middle section

section.mid[1] = {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = function ()
      local tbl = {['dashboard'] = true,['']=true}
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    icon = '  LSP:',
    highlight = {theme.fg_alt, theme.bg}
  }
}

-- }}}

-- {{{ Right section

section.right[1] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.fg_alt, theme.bg},
  },
}

section.right[2] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.fg_alt, theme.bg},
  }
}

section.right[3] = {
  FileTypeName = {
    provider = 'FileTypeName',
    condition = cond.buffer_not_empty,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.cyan, theme.bg}
  }
}

section.right[4] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = cond.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.magenta, theme.bg},
  }
}

section.right[5] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = cond.check_git_workspace,
    highlight = {theme.magenta, theme.bg},
  }
}

section.right[6] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = cond.hide_in_width,
    icon = '  ',
    highlight = {theme.green, theme.bg},
  }
}
section.right[7] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = cond.hide_in_width,
    icon = ' 柳',
    highlight = {theme.orange, theme.bg},
  }
}
section.right[8] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = cond.hide_in_width,
    icon = '  ',
    highlight = {theme.red, theme.bg},
  }
}

section.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.blue, theme.bg, 'bold'}
  }
}

section.short_line_left[2] = {
  SFileName = {
    provider =  'SFileName',
    condition = cond.buffer_not_empty,
    highlight = {theme.fg, theme.bg, 'bold'}
  }
}

section.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {theme.fg, theme.bg}
  }
}

-- }}}

-- }}}

-- {{{ Initialization

require('nvim-web-devicons').setup(devicons_opts)
require('galaxyline').short_line_list = short_line_list

-- }}}

-- vim:foldmethod=marker
