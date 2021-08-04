vim.cmd('packadd! nvim-lspconfig')

local lsp = require('lspconfig')

function hover()
  if next(vim.lsp.buf_get_clients()) == nil then
     vim.cmd [[execute printf('h %s', expand('<cword>'))]]
  else
    vim.lsp.buf.hover()
  end
end

function definition()
  if next(vim.lsp.buf_get_clients()) == nil then
     vim.cmd [[execute printf('tag %s', expand('<cword>'))]]
  else
    require'telescope.builtin'.lsp_definitions({previewer = false})
  end
end

local map_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua hover()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<c-]>', '<cmd>lua definition()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-R>', "<cmd>lua vim.lsp.buf.rename()<cr>", map_opts)

function attach_lsp_highlight(client)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

function attach_lsp_formatting(client)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_document_formatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]], false)
  end
end

function attach_prettier_formatting()
  vim.api.nvim_exec([[
    augroup lsp_document_formatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> PrettierAsync
    augroup END
  ]], false)
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = false,
  }
)

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true;

local default_on_attach = function(client)
  attach_lsp_highlight(client)
  attach_lsp_formatting(client)
end

function default_setup()
  return {
    capabilities = default_capabilities,
    on_attach = default_on_attach,
  }
end

-- {{{ Markdown

lsp.zeta_note.setup({
  cmd = {
    '/opt/zeta-note',
  },
  root_dir = function(fname)
    return '/home/soywod/Documents'
  end,
})

-- }}}

-- {{{ Bash

lsp.bashls.setup({
  capabilities = default_capabilities,
  on_attach = default_on_attach,
})

-- }}}

-- {{{ JSON

lsp.jsonls.setup({
  capabilities = default_capabilities,
  on_attach = default_on_attach,
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"),0})
      end
    }
  }
})

-- }}}

-- {{{ CSS

lsp.cssls.setup(default_setup())

-- }}}

-- {{{ Rust

lsp.rust_analyzer.setup(default_setup())

-- }}}

-- {{{ TypeScript

lsp.tsserver.setup {
  capabilities = default_capabilities,
  on_attach = function(client)
    attach_lsp_highlight(client)
    attach_prettier_formatting(client)
  end,
}

-- }}}

-- {{{ OCaml

lsp.ocamllsp.setup(default_setup())

-- }}}

-- vim:foldmethod=marker
