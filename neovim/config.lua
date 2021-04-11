-- Plugins

local plugins = {
  'lsp-status.nvim',
  'nvim-compe',
  'nvim-lspconfig',
  'nvim-treesitter',
  'plenary.nvim',
  'popup.nvim',
  'snippets.nvim',
  'telescope.nvim',
  'vim-prettier',
}

for _, plugin in ipairs(plugins) do
  vim.cmd('packadd! '..plugin)
end

vim.g['prettier#config#config_precedence'] = 'prefer-file'

-- Tree sitter
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local tree_sitter_languages = {
  'bash',
  'css',
  'html',
  'javascript',
  'json',
  'ledger',
  'lua',
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
      init_selection = 'gs',
      node_incremental = '<cr>',
      node_decremental = '<s-cr>',
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
  }
}

-- Status line

local lsp_status = require('lsp-status')

lsp_status.register_progress()
lsp_status.config({
  indicator_errors = '',
  indicator_warnings = '',
  indicator_info = '',
  indicator_hint = '',
  indicator_ok = '',
  status_symbol = '[LSP] ',
})

function LspStatusLine()
  if next(vim.lsp.buf_get_clients()) == nil then
    return ''
  else
    return lsp_status.status()
  end
end

-- Completion

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'disable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = false;
    vsnip = false;
  };
}

-- LSP

local lspconfig = require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;

function UseLspDiagnostics()
  vim.api.nvim_exec([[
    augroup lsp_diagnostics
      autocmd! * <buffer>
      autocmd CursorHold  <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()
    augroup END
  ]], false)
end

function UseLspHighlight(client)
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

function UseLspFormatting(client)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_document_formatting
	autocmd! * <buffer>
	autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]], false)
  end
end

function UsePrettierFormatting()
  vim.api.nvim_exec([[
    augroup lsp_document_formatting
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> Prettier
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
  lsp_status.on_attach(client)
  UseLspHighlight(client)
  UseLspDiagnostics()
  UseLspFormatting(client)
end

-- LSP Rust

lspconfig.rust_analyzer.setup {
  capabilities = default_capabilities,
  on_attach = default_on_attach,
}

-- LSP TypeScript

local typescript_capabilities = vim.lsp.protocol.make_client_capabilities()
typescript_capabilities.textDocument.completion.completionItem.snippetSupport = true;
typescript_capabilities.textDocument.formatting = false;

lspconfig.tsserver.setup {
  capabilities = typescript_capabilities,
  on_attach = function(client)
    lsp_status.on_attach(client)
    UseLspHighlight(client)
    UseLspDiagnostics()
    UsePrettierFormatting()
  end,
}

-- LSP Lua

local sumneko_root_path = '/opt/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
lspconfig.sumneko_lua.setup {
  capabilities = default_capabilities,
  on_attach = function(client)
    lsp_status.on_attach(client)
    UseLspHighlight(client)
    UseLspDiagnostics()
    UseLspFormatting(client)
  end,
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'};
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Snippets

require'snippets'.snippets = {
  _global = {
    -- TODO
  }
}

-- Vim settings

vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.undofile = true
vim.o.background = 'dark'
vim.o.completeopt = 'menuone,noselect'
vim.o.foldlevelstart = 99
vim.o.hidden = true
vim.o.pumheight = 12
vim.o.ruler = false
vim.o.shortmess = 'ctT'
vim.o.showbreak = '~'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.statusline = '%m%{luaeval("LspStatusLine()")}%=%r%y'
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.o.writebackup = false
vim.wo.breakindent = true
vim.wo.breakindentopt = 'sbr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldmethod = 'expr'
vim.wo.number = true
vim.wo.relativenumber = true

-- Theme
-- https://github.com/arcticicestudio/nord-vim

vim.cmd [[syntax on
highlight Boolean			  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Character   	      	      	  guifg=#a3be8c guibg=NONE    gui=NONE
highlight Comment	      	      	  guifg=#4c566a guibg=NONE    gui=NONE
highlight Conditional 	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Constant    	      	      	  guifg=#d8dee9 guibg=NONE    gui=NONE
highlight CursorLineNr        	      	  guifg=#ebcb8b guibg=NONE    gui=NONE
highlight Define      	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Delimiter   	      	      	  guifg=#eceff4 guibg=NONE    gui=NONE
highlight Error               	      	  guifg=#d8dee9 guibg=#bf616a gui=NONE
highlight ErrorMsg            	      	  guifg=#bf616a guibg=NONE    gui=bold
highlight Exception   	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Float	      	      	      	  guifg=#b48ead guibg=NONE    gui=NONE
highlight Folded              	      	  guifg=#4c566a guibg=NONE    gui=NONE
highlight Function    	      	      	  guifg=#88c0d0 guibg=NONE    gui=NONE
highlight Identifier  	      	      	  guifg=#d8dee9 guibg=NONE    gui=NONE
highlight IncSearch              	  guifg=#d8dee9 guibg=#d08770 gui=NONE
highlight Include     	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Keyword     	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Label	      	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight LineNr	      	      	  guifg=#4c566a guibg=NONE    gui=NONE
highlight LspDiagnosticsFloatingError	  guifg=NONE	guibg=NONE    gui=NONE
highlight LspDiagnosticsFloatingHint	  guifg=NONE	guibg=NONE    gui=NONE
highlight LspDiagnosticsFloatingWarning	  guifg=NONE	guibg=NONE    gui=NONE
highlight LspDiagnosticsUnderlineError	  guifg=#d8dee9 guibg=#bf616a gui=NONE
highlight LspDiagnosticsUnderlineHint	  guifg=#3b4252 guibg=#b48ead gui=NONE
highlight LspDiagnosticsUnderlineInfo	  guifg=#3b4252	guibg=#b48ead gui=NONE
highlight LspDiagnosticsUnderlineWarning  guifg=#3b4252 guibg=#ebcb8b gui=NONE
highlight LspReferenceRead	          guifg=NONE	guibg=#434c5e gui=NONE
highlight LspReferenceText                guifg=NONE    guibg=#434c5e gui=NONE
highlight LspReferenceWrite	          guifg=NONE    guibg=#434c5e gui=NONE
highlight MatchParen          	      	  guifg=#88c0d0 guibg=NONE    gui=bold,underline
highlight NonText	      	      	  guifg=#4c566a guibg=NONE    gui=NONE
highlight Number      	      	      	  guifg=#b48ead guibg=NONE    gui=NONE
highlight Operator    	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Pmenu				  guifg=#d8dee9 guibg=#3b4252 gui=NONE
highlight PmenuSel              	  guifg=#d8dee9 guibg=#d08770 gui=NONE
highlight PreProc     	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Repeat      	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Search              	      	  guifg=#d8dee9 guibg=#d08770 gui=NONE
highlight Special     	      	      	  guifg=#d8dee9 guibg=NONE    gui=NONE
highlight SpecialChar 	      	      	  guifg=#ebcb8b guibg=NONE    gui=NONE
highlight SpecialComment      	      	  guifg=#88c0d0 guibg=NONE    gui=italic
highlight Statement	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight StatusLine          	      	  guifg=#d8dee9 guibg=#3b4252 gui=NONE
highlight StatusLineNC	      	      	  guifg=#d8dee9 guibg=#3b4252 gui=NONE
highlight StorageClass	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight String	      	      	  guifg=#a3be8c guibg=NONE    gui=NONE
highlight Structure	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight TabLine             	      	  guifg=#d8dee9 guibg=#2e3440 gui=NONE
highlight TabLineFill         	      	  guifg=#d8dee9 guibg=#2e3440 gui=NONE
highlight TabLineSel          	      	  guifg=#2e3440 guibg=#d8dee9 gui=NONE
highlight Tag		      	      	  guifg=#d8dee9 guibg=NONE    gui=NONE
highlight TelescopeBorder        	  guifg=#d8dee9 guibg=NONE    gui=NONE
highlight TelescopeMatching               guifg=#eceff4 guibg=#d08770 gui=NONE
highlight TelescopeMultiSelection	  guifg=#d08770 guibg=NONE    gui=NONE
highlight TelescopeNormal        	  guifg=#d8dee9 guibg=#2e3440 gui=NONE
highlight TelescopeResultsBorder          guifg=#4c566a guibg=NONE    gui=NONE
highlight TelescopeSelection	      	  guifg=#d8dee9	guibg=#434c5e gui=NONE
highlight Todo		      	      	  guifg=#ebcb8b guibg=NONE    gui=NONE
highlight Type		      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Typedef	      	      	  guifg=#81a1c1 guibg=NONE    gui=NONE
highlight Visual	      	      	  guifg=#d8dee9	guibg=#434c5e gui=NONE
highlight Warning			  guifg=#3b4252 guibg=#ebcb8b gui=NONE
highlight WarningMsg			  guifg=#ebcb8b guibg=NONE    gui=bold
]]

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

vim.api.nvim_set_keymap('i', '<tab>'  , 'pumvisible() ? "\\<c-n>" : "\\<tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<cr>'   , 'compe#confirm("\\<cr>")', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<a-cr>' , "<cmd>lua require'snippets'.expand_or_advance(1)<cr>", map_opts)

vim.api.nvim_set_keymap('n', '<a-cr>' , "<cmd>lua require'snippets'.expand_or_advance(1)<cr>", map_opts)
vim.api.nvim_set_keymap('n', 'K'    , '<cmd>lua Hover()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<c-]>', '<cmd>lua Definition()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-f>', "<cmd>lua require'telescope.builtin'.find_files({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-h>', "<cmd>lua require'telescope.builtin'.oldfiles({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-g>', "<cmd>lua require'telescope.builtin'.live_grep({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-b>', "<cmd>lua require'telescope.builtin'.buffers({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-d>', "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-D>', "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-c>', "<cmd>lua require'telescope.builtin'.lsp_code_actions({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-p>', "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-n>', "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-w>', "<cmd>lua require'telescope.builtin'.lsp_document_symbols({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-W>', "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-t>', '<cmd>lua vim.lsp.buf.type_definition()<cr>', map_opts)
vim.api.nvim_set_keymap('n', '<a-r>', "<cmd>lua require'telescope.builtin'.lsp_references({previewer = false})<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-R>', "<cmd>lua vim.lsp.buf.rename()<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-i>', "<cmd>lua require'telescope.builtin'.lsp_implementation({previewer = false})<cr>", map_opts)
