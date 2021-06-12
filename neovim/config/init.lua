-- Plugins

local plugins = {
  'nvim-lspconfig',   -- ├ LSP
  'nvim-treesitter',  -- ├ Tree sitter
  'nvim-compe',       -- ├ Completion

  'popup.nvim',       -- ├ Fuzzy stuff
  'plenary.nvim',     -- │
  'telescope.nvim',   -- │

  'nvim-web-devicons',-- ├ Status line
  'galaxyline.nvim',  -- │

  'ultisnips',        -- ├ Snippets

  'zeta-note',        -- ├ Markdown
  'vim-markdown',     -- │

  'vim-abolish',      -- ├ Utils
  'vim-commentary',   -- │
  'vim-gnupg',        -- │
  'vim-prettier',     -- │
  'vim-repeat',       -- │
  'vim-surround',     -- │
  'emmet-vim',        -- │
  'vim-ledger',       -- │

}

for _, plugin in ipairs(plugins) do
  vim.cmd('packadd! '..plugin)
end

require('status-line')

-- Plugins global setup

vim.g['prettier#config#config_precedence'] = 'prefer-file'
vim.g['user_emmet_install_global'] = 0
vim.g['user_emmet_mode'] = 'i'
vim.g['user_emmet_leader_key'] = ','
vim.g['UltiSnipsExpandTrigger'] = '<m-cr>'
vim.g['UltiSnipsJumpForwardTrigger'] = '<cr>'

-- Tree sitter
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local tree_sitter_languages = {
  'bash',
  'css',
  'html',
  'javascript',
  'json',
  -- 'ledger',
  'lua',
  'ocaml',
  'php',
  'rust',
  'toml',
  'tsx',
  'typescript',
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = tree_sitter_languages,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<a-v>',
      node_incremental = '<a-v>',
      node_decremental = '<a-V>',
    },
  },
}

-- Telescope

require'telescope'.setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require'telescope.actions'.close
      },
    },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  }
}

-- Completion

require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'disable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    ultisnips = true,
  },
}

-- LSP

local lspconfig = require('lspconfig')

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

-- LSP Markdown

lspconfig.zeta_note.setup {
  cmd = {'/opt/zeta-note'},
  root_dir = function(fname)
    return '/home/soywod/Documents'
  end,
}

-- LSP Bash

lspconfig.bashls.setup {
  capabilities = default_capabilities,
  on_attach = default_on_attach,
}

-- LSP JSON

lspconfig.jsonls.setup {
  capabilities = default_capabilities,
  on_attach = default_on_attach,
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"),0})
      end
    }
  }
}

-- LSP CSS

lspconfig.cssls.setup {
  capabilities = default_capabilities,
  on_attach = default_on_attach,
}

-- LSP Rust

lspconfig.rust_analyzer.setup {
  capabilities = default_capabilities,
  on_attach = default_on_attach,
}

-- LSP TypeScript

lspconfig.tsserver.setup {
  capabilities = default_capabilities,
  on_attach = function(client)
    attach_lsp_highlight(client)
    attach_prettier_formatting(client)
  end,
  cmd = {"typescript-language-server", "--stdio"}
}

-- LSP OCaml

lspconfig.ocamllsp.setup{
  capabilities = default_capabilities,
  on_attach = default_on_attach,
}

-- Vim settings

vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.o.background = 'dark'
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menuone,noselect'
vim.o.expandtab = true
vim.o.foldlevelstart = 99
vim.o.hidden = true
vim.o.pumheight = 12
vim.o.ruler = false
vim.o.runtimepath = vim.o.runtimepath..',~/Code/himalaya/vim'
vim.o.runtimepath = vim.o.runtimepath..',~/Code/unfog.vim'
vim.o.shiftwidth = 2
vim.o.shortmess = 'ctT'
vim.o.showbreak = '~'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.writebackup = false
vim.wo.breakindent = true
vim.wo.breakindentopt = 'sbr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldmethod = 'expr'
vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd [[
augroup emmet
  autocmd FileType html,typescriptreact,css,scss EmmetInstall
augroup END
]]

function LedgerFormat()
  vim.cmd "mkview"
  vim.cmd "LedgerAlignBuffer"
  vim.cmd "silent! loadview"
end

vim.api.nvim_exec([[
augroup ledger
  autocmd BufWritePre *.ledger lua LedgerFormat()
augroup END
]], false)

-- Theme
-- https://github.com/hlissner/emacs-doom-themes/blob/master/themes/doom-one-theme.el

vim.cmd [[syntax on
highlight Normal													guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Character   	      	      	  guifg=#98be65 guibg=NONE    gui=NONE
highlight String	      	      	  	    guifg=#98be65 guibg=NONE    gui=NONE
highlight Boolean			  	                guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Number      	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Float	      	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Constant    	      	      	  guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight Type		      	      	        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Typedef	      	      	        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Function    	      	      	  guifg=#c678dd guibg=NONE    gui=NONE
highlight IncSearch              	        guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight Search              	      	  guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight StatusLine          	      	  guifg=#bbc2cf guibg=#21242b gui=NONE
highlight StatusLineNC	      	      	  guifg=#5b6268 guibg=#21242b gui=NONE
highlight Identifier  	      	      	  guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight Pmenu				                    guifg=#bbc2cf guibg=#21242b gui=NONE
highlight PmenuSel              	        guifg=#bbc2cf guibg=#2257a0 gui=NONE
highlight Title		      	      	        guifg=#ff6c6b guibg=NONE    gui=NONE
highlight NonText	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Comment	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Folded              	      	  guifg=#5b6268 guibg=NONE    gui=NONE
highlight LineNr	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight VertSplit	      	      	      guifg=#3f444a guibg=NONE    gui=NONE
highlight CursorLine        	      	    guifg=NONE    guibg=#21242b gui=NONE
highlight CursorLineNr        	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight MatchParen          	      	  guifg=#ff6c6b guibg=#21242b gui=bold
highlight SpecialComment      	      	  guifg=#bbc2cf guibg=NONE    gui=italic
highlight Delimiter   	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Visual	      	      	        guifg=NONE	  guibg=#3f444a gui=NONE

highlight Statement	      	      	      guifg=#51afef guibg=NONE    gui=NONE
highlight Conditional 	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Define      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Exception   	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Include     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Keyword     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Label	      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Operator    	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight PreProc     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Repeat      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight StorageClass	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Structure	      	      	      guifg=#51afef guibg=NONE    gui=NONE

highlight Special     	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Tag		      	      	          guifg=#c678dd guibg=NONE    gui=NONE
highlight TabLine             	      	  guifg=#bbc2cf guibg=#2e3440 gui=NONE
highlight TabLineFill         	      	  guifg=#bbc2cf guibg=#2e3440 gui=NONE
highlight TabLineSel          	      	  guifg=#2e3440 guibg=#bbc2cf gui=NONE
highlight TelescopeBorder        	        guifg=#c678dd guibg=NONE    gui=NONE
highlight TelescopeResultsBorder          guifg=#3f444a guibg=NONE    gui=NONE
highlight TelescopeNormal        	        guifg=#bbc2cf guibg=NONE    gui=NONE
highlight TelescopeSelection	      	    guifg=#bbc2cf	guibg=#3f444a gui=NONE
highlight TelescopeMatching              	guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight TelescopeSelectionCaret	      	guifg=#c678dd	guibg=#3f444a gui=NONE
highlight TelescopePromptPrefix           guifg=#c678dd guibg=NONE    gui=bold
highlight TelescopeMultiSelection	        guifg=#c678dd guibg=NONE    gui=NONE
highlight Error               	      	  guifg=#ff6c6b guibg=NONE    gui=bold
highlight ErrorMsg            	      	  guifg=#ff6c6b guibg=NONE    gui=bold
highlight LspDiagnosticsUnderlineError	  guifg=#282c34 guibg=#ff6c6b gui=NONE
]]

-- Emails

vim.cmd [[
highlight! link mailSubject mailHeaderKey
highlight! link mailEmail mailURL

highlight mailURL guifg=#51afef guibg=NONE gui=NONE
]]

-- highlight SpecialChar 	      	      	  guifg=#da8548 guibg=NONE    gui=NONE

-- vim.cmd [[
-- highlight LspDiagnosticsFloatingError	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsFloatingHint	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsFloatingWarning	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsUnderlineHint	  guifg=#3b4252 guibg=#b48ead gui=NONE
-- highlight LspDiagnosticsUnderlineInfo	  guifg=#3b4252	guibg=#b48ead gui=NONE
-- highlight LspDiagnosticsUnderlineWarning  guifg=#3b4252 guibg=#ebcb8b gui=NONE
-- highlight LspReferenceRead	          guifg=NONE	guibg=#434c5e gui=NONE
-- highlight LspReferenceText                guifg=NONE    guibg=#434c5e gui=NONE
-- highlight LspReferenceWrite	          guifg=NONE    guibg=#434c5e gui=NONE
-- highlight Todo		      	      	  guifg=#ebcb8b guibg=NONE    gui=NONE
-- highlight Warning			  guifg=#3b4252 guibg=#ebcb8b gui=NONE
-- highlight WarningMsg			  guifg=#ebcb8b guibg=NONE    gui=bold
-- ]]

-- Mappings

function Hover()
  if next(vim.lsp.buf_get_clients()) == nil then
     vim.cmd [[execute printf('h %s', expand('<cword>'))]]
  else
    vim.lsp.buf.hover()
  end
end

function Definition()
  if next(vim.lsp.buf_get_clients()) == nil then
     vim.cmd [[execute printf('tag %s', expand('<cword>'))]]
  else
    require'telescope.builtin'.lsp_definitions({previewer = false})
  end
end

local map_opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('i', '<cr>'   , 'compe#confirm("\\<cr>")', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<tab>'  , 'pumvisible() ? "\\<c-n>" : "\\<tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "<s-tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('n', 'K'      , '<cmd>lua Hover()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<c-]>'  , '<cmd>lua Definition()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-f>'  , "<cmd>lua require'telescope.builtin'.find_files({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-F>'  , "<cmd>lua require'telescope.builtin'.file_browser({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-h>'  , "<cmd>lua require'telescope.builtin'.oldfiles({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-g>'  , "<cmd>lua require'telescope.builtin'.live_grep({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-b>'  , "<cmd>lua require'telescope.builtin'.buffers({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-d>'  , "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-D>'  , "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-c>'  , "<cmd>lua require'telescope.builtin'.lsp_code_actions({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-p>'  , "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-n>'  , "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-w>'  , "<cmd>lua require'telescope.builtin'.lsp_document_symbols({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-W>'  , "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols({previewer = false})<cr>", map_opts)
-- vim.api.nvim_set_keymap('n', '<a-t>'  , '<cmd>lua vim.lsp.buf.type_definition()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-r>'  , "<cmd>lua require'telescope.builtin'.lsp_references({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-R>'  , "<cmd>lua vim.lsp.buf.rename()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-i>'  , "<cmd>lua require'telescope.builtin'.lsp_implementation({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-m>'  , ":Himalaya<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<a-t>'  , ":Unfog<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<a-s>'  , ":UltiSnipsEdit<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<a-e>'  , ":Explore<cr>", {noremap = true, silent = true})
