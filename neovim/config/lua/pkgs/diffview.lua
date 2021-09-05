--- Diffview module.
-- Module for better file diff.
-- https://github.com/sindrets/diffview.nvim
-- @module pkgs.diffview
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! diffview.nvim')

local diffview = require('diffview')

diffview.setup({
  signs = {
    fold_closed = "+",
    fold_open = "-",
  },
})

function _G.diffview_apply_tweaks()
  local StandardView = require('diffview.views.standard.standard_view').StandardView
  vim.schedule(function ()
    local view = require('diffview.lib').get_current_view()
    if view and view:instanceof(StandardView) then
      local curhl = vim.wo[view.left_winid].winhl
      vim.wo[view.left_winid].winhl = table.concat({
        "DiffAdd:DiffAddAsDelete",
        curhl ~= "" and curhl or nil
      }, ",")
    end
  end)
end

vim.api.nvim_exec([[
    augroup diffview_config
      au!
      au TabNew * lua diffview_apply_tweaks()
    augroup END
]], false)
