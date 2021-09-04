vim.cmd('packadd! vim-ledger')

function ledger_format()
  vim.cmd "mkview"
  vim.cmd "LedgerAlignBuffer"
  vim.cmd "silent! loadview"
end

vim.api.nvim_exec([[
  augroup ledger
    autocmd BufWritePre *.ledger lua ledger_format()
  augroup END
]], false)

