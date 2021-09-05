--- LSP module.
-- Module for managing LSP clients.
-- https://github.com/neovim/nvim-lspconfig
-- @module pkgs.lsp
-- @author soywod <clement.douin@posteo.net>

-- LSP status line

vim.cmd('packadd! lsp-status.nvim')

local lsp_status = require('lsp-status')

lsp_status.register_progress()
lsp_status.config({
  indicator_info = '',
  indicator_hint = '',
  indicator_warnings = '',
  indicator_errors = '',
  indicator_ok = '',
  status_symbol = '[LSP] ',
})

function lsp_status_line()
  if next(vim.lsp.buf_get_clients()) == nil then
    return ''
  else
    return lsp_status.status()
  end
end

-- LSP

vim.cmd('packadd! nvim-lspconfig')

local lsp = require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

function hover()
  if next(vim.lsp.buf_get_clients()) == nil then
    vim.cmd('execute printf("h %s", expand("<cword>"))')
  else
    vim.lsp.buf.hover()
  end
end

function definition()
  if next(vim.lsp.buf_get_clients()) == nil then
    vim.cmd('execute printf("tag %s", expand("<cword>"))')
  else
    require('telescope.builtin').lsp_definitions({previewer = false})
  end
end

local format_async = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command('noautocmd :update')
    end
  end
end

_G.lsp_organize_imports = function()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

vim.lsp.handlers["textDocument/formatting"] = format_async
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = false,
  }
)

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client)

  -- vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  -- vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
  -- vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  -- vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  -- vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  -- vim.cmd("command! LspOrganize lua lsp_organize_imports()")
  -- vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  -- vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  -- vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  -- vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
  -- vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
  -- vim.cmd("command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
  -- vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
  -- buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
  -- buf_map(bufnr, "n", "gr", ":LspRename<CR>", {silent = true})
  -- buf_map(bufnr, "n", "gR", ":LspRefs<CR>", {silent = true})
  -- buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
  -- buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
  -- buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
  -- buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>", {silent = true})
  -- buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>", {silent = true})
  -- buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
  -- buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", {silent = true})
  -- buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp-formatting
        autocmd! * <buffer>
        autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()
      augroup END
    ]], true)
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp-highlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], true)
  end

  local buf_map = vim.api.nvim_buf_set_keymap
  local buf_map_opts = {noremap = true, silent = true}
  buf_map(bufnr, 'n', 'K'    , '<cmd>lua hover()<cr>', buf_map_opts)
  buf_map(bufnr, 'n', '<c-]>', '<cmd>lua definition()<cr>', buf_map_opts)
  buf_map(bufnr, 'n', '<a-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', buf_map_opts)
  buf_map(bufnr, 'n', '<a-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', buf_map_opts)
  buf_map(bufnr, 'n', '<a-R>', '<cmd>lua vim.lsp.buf.rename()<cr>', buf_map_opts)
end

-- {{{ Diagnostics

local filetypes = {
  javascript = 'eslint',
  javascriptreact = 'eslint',
  typescript = 'eslint',
  typescriptreact = 'eslint',
}

local linters = {
  eslint = {
    sourceName = 'eslint',
    command = 'node_modules/.bin/eslint',
    rootPatterns = {'package.json', '.eslintrc.js', 'eslint.config.js'},
    debounce = 100,
    args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
    parseJson = {
      errorsRoot = '[0].messages',
      line = 'line',
      column = 'column',
      endLine = 'endLine',
      endColumn = 'endColumn',
      message = '${message} [${ruleId}]',
      security = 'severity'
    },
    securities = {[2] = 'error', [1] = 'warning'}
  }
}

local formatters = {
  prettier = {
    command = 'node_modules/.bin/prettier',
    rootPatterns = {'.prettierrc', '.prettierrc.js'},
    args = {'--stdin-filepath', '%filepath'},
  }
}

local formatFiletypes = {
  css = 'prettier',
  javascript = 'prettier',
  javascriptreact = 'prettier',
  scss = 'prettier',
  typescript = 'prettier',
  typescriptreact = 'prettier',
}

lsp.diagnosticls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = vim.tbl_keys(formatFiletypes),
  init_options = {
    filetypes = filetypes,
    linters = linters,
    formatters = formatters,
    formatFiletypes = formatFiletypes,
  },
})

-- }}}

-- {{{ Bash

lsp.bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- }}}

-- {{{ JSON

lsp.jsonls.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end,
})

-- }}}

-- {{{ CSS

lsp.cssls.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end,
})

-- }}}

-- {{{ Rust

lsp.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- }}}

-- {{{ TypeScript

lsp.tsserver.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end,
})

-- }}}

-- {{{ OCaml

lsp.ocamllsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- }}}

-- {{{ GraphQL

lsp.graphql.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- }}}

-- vim:foldmethod=marker
