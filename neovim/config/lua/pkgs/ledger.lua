--- Ledger module.
-- Module for ledger accounting files.
-- https://github.com/ledger/vim-ledger
-- @module pkgs.ledger
-- @author soywod <clement.douin@posteo.net>

vim.cmd('packadd! vim-ledger')

function ledger_format()
  vim.cmd('mkview')
  vim.cmd('LedgerAlignBuffer')
  vim.cmd('silent! loadview')
end

vim.api.nvim_exec([[
  augroup ledger
    autocmd! * <buffer>
    autocmd BufWritePre *.ledger lua ledger_format()
  augroup END
]], false)
