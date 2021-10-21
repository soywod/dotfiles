local M = {}

M.setup = function()
  vim.api.nvim_exec([[
  augroup autocompletion
    autocmd! * <buffer>
    autocmd CursorHoldI <buffer> lua require('lsp-completion').complete()
  augroup END
  ]], true)
end

M.complete = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  -- TODO: skip other chars like '(', '{' and '['
  local space_behind_cursor = (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
  if not space_behind_cursor then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<c-x><c-o>", true, true, true))
  end
end

return M
