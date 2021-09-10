--- Galaxyline module.
-- Module for better status bar management.
-- https://github.com/glepnir/galaxyline.nvim
-- @module pkgs.galaxyline
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! galaxyline.nvim')

local galaxyline = require('galaxyline')
local section = require('galaxyline').section
local cond = require('galaxyline.condition')
local lsp_status = require('lsp-status')
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
  red = '#ff6c6b',
}

galaxyline.short_line_list = {
  'NvimTree',
  'vista',
  'dbui',
  'packer',
}

section.left = {
  { 
    ShowLspClient = {
      provider = function()
        local output = ""
        for _, message in ipairs(lsp_status.messages()) do
          if message.progress then
            output = message.title
            if message.message then
              output = output..': '..message.message
            end
            return output
          end
        end
        if vim.b.lsp_current_function and vim.b.lsp_current_function ~= '' then
          output = output..'λ('..vim.b.lsp_current_function..')'
        end
        return output
      end,
      condition = function ()
        local tbl = {['dashboard'] = true, [''] = true}
        return not tbl[vim.bo.filetype]
      end,
      icon = '  LSP: ',
      highlight = {theme.fg_alt, theme.bg},
    },
  },
  { 
    DiagnosticError = {
      provider = 'DiagnosticError',
      icon = '  ',
      highlight = {theme.red, theme.bg},
    },
  },
  { 
    DiagnosticWarn = {
      provider = 'DiagnosticWarn',
      icon = '  ',
      highlight = {theme.yellow, theme.bg},
    }
  },
  { 
    DiagnosticHint = {
      provider = 'DiagnosticHint',
      icon = '  ',
      highlight = {theme.cyan, theme.bg},
    },
  },
  { 
    DiagnosticInfo = {
      provider = 'DiagnosticInfo',
      icon = '  ',
      highlight = {theme.blue, theme.bg},
    },
  },
}

section.right = {
  { 
    LineInfo = {
      provider = 'LineColumn',
      separator = ' ',
      separator_highlight = {'NONE', theme.bg},
      highlight = {theme.fg_alt, theme.bg},
    },
  },
  {
    PerCent = {
      provider = 'LinePercent',
      separator = ' ',
      separator_highlight = {'NONE', theme.bg},
      highlight = {theme.fg_alt, theme.bg},
    },
  },
  {
    FileTypeName = {
      provider = 'FileTypeName',
      condition = cond.buffer_not_empty,
      separator = ' ',
      separator_highlight = {'NONE', theme.bg},
      highlight = {theme.cyan, theme.bg},
    },
  },
  {
    GitIcon = {
      provider = function() return '  ' end,
      condition = cond.check_git_workspace,
      separator = ' ',
      separator_highlight = {'NONE', theme.bg},
      highlight = {theme.magenta, theme.bg},
    },
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = cond.check_git_workspace,
      highlight = {theme.magenta, theme.bg},
    },
  },
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = cond.hide_in_width,
      icon = '  ',
      highlight = {theme.green, theme.bg},
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = cond.hide_in_width,
      icon = ' 柳',
      highlight = {theme.orange, theme.bg},
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = cond.hide_in_width,
      icon = '  ',
      highlight = {theme.red, theme.bg},
    },
  },
}

section.short_line_left = { 
  {
    BufferType = {
      provider = 'FileTypeName',
      separator = ' ',
      separator_highlight = {'NONE', theme.bg},
      highlight = {theme.blue, theme.bg, 'bold'},
    },
  },
  {
    SFileName = {
      provider =  'SFileName',
      condition = cond.buffer_not_empty,
      highlight = {theme.fg, theme.bg, 'bold'},
    },
  },
}

section.short_line_right = { 
  {
    BufferIcon = {
      provider= 'BufferIcon',
      highlight = {theme.fg, theme.bg},
    },
  },
}
