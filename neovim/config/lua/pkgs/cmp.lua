--- Cmp module.
-- Module for better completion.
-- https://github.com/hrsh7th/nvim-cmp
-- @module pkgs.cmp
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! cmp-nvim-ultisnips')
vim.cmd('packadd! cmp-nvim-lsp')
vim.cmd('packadd! cmp-nvim-lua')
vim.cmd('packadd! cmp-path')
vim.cmd('packadd! cmp-buffer')
vim.cmd('packadd! nvim-cmp')

local cmp = require('cmp')
local cmp_keymap = require('cmp.utils.keymap')

function feedkeys(keys)
  vim.fn.feedkeys(cmp_keymap.t(keys))
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },
  mapping = {
    ['<s-tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
    ['<tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<cr>'] = cmp.mapping(function(fallback)
      if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
        feedkeys('<c-r>=UltiSnips#ExpandSnippet()<cr>')
      elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        feedkeys('<c-r>=UltiSnips#JumpForwards()<cr>')
      elseif vim.fn.pumvisible() == 1 and vim.fn.complete_info()["selected"] > -1 then
        cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
      else
        fallback()
      end
    end, {'i', 's'}),
  },
  sources = {
    {name = 'ultisnips'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'path'},
    {name = 'buffer'},
  },
})

-- vim:foldmethod=marker
