require('nvim-web-devicons').setup {
  default = true,
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

local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui','packer'}

local condition = require('galaxyline.condition')

gls.left[1] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, theme.bg},
  },
}

gls.left[2] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.blue, theme.bg, 'bold'}
  }
}

gls.left[3] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {theme.red, theme.bg}
  }
}
gls.left[4] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {theme.yellow, theme.bg},
  }
}

gls.left[5] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {theme.cyan, theme.bg},
  }
}

gls.left[6] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {theme.blue, theme.bg},
  }
}

gls.mid[1] = {
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

gls.right[1] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.fg_alt, theme.bg},
  },
}

gls.right[2] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.fg_alt, theme.bg},
  }
}

gls.right[3] = {
  FileTypeName = {
    provider = 'FileTypeName',
    condition = condition.buffer_not_empty,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.cyan, theme.bg}
  }
}

gls.right[4] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.magenta, theme.bg},
  }
}

gls.right[5] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {theme.magenta, theme.bg},
  }
}

gls.right[6] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {theme.green, theme.bg},
  }
}
gls.right[7] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {theme.orange, theme.bg},
  }
}
gls.right[8] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {theme.red, theme.bg},
  }
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE', theme.bg},
    highlight = {theme.blue, theme.bg, 'bold'}
  }
}

gls.short_line_left[2] = {
  SFileName = {
    provider =  'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {theme.fg, theme.bg, 'bold'}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {theme.fg, theme.bg}
  }
}
