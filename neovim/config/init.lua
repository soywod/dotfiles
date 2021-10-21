local use_plugin = require('plugin').setup().use

use_plugin('jamessan/vim-gnupg')

use_plugin('tpope/vim-surround')
use_plugin('tpope/vim-abolish')
use_plugin('tpope/vim-commentary')
use_plugin('tpope/vim-repeat')

use_plugin('junegunn/fzf')
use_plugin({
  'junegunn/fzf.vim',
  config = function()
    -- Config
    vim.g.fzf_preview_window = {}
    vim.g.fzf_layout = {down = '~40%'}

    -- Mapping
    vim.api.nvim_set_keymap('n', '<a-f>', ':Files<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<a-b>', ':Buffers<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<a-o>', ':History<cr>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<a-g>', ':Rg ', {noremap = true})

    -- Theming
    vim.cmd('highlight fzf1 guifg=#c678dd guibg=#21242b gui=NONE')
    vim.cmd('highlight fzf2 guifg=#bbc2cf guibg=#21242b gui=NONE')
    vim.cmd('highlight! link fzf3 fzf2')
  end
})

use_plugin({
  'sirver/ultisnips',
  config = function()
  -- Config
  vim.g.UltiSnipsExpandTrigger = '<noop>'
  vim.g.UltiSnipsJumpBackwardTrigger = '<noop>'
  vim.g.UltiSnipsJumpForwardTrigger = '<noop>'
  vim.g.UltiSnipsEditSplit = 'vertical'

  -- Mapping
  vim.api.nvim_set_keymap('n', '<a-s>', ':UltiSnipsEdit<cr>', {noremap = true, silent = true})
end,
})

-- LSP
use_plugin({
  'neovim/nvim-lspconfig',
  config = function()
    local lsp = require('lspconfig')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    function hover()
      if next(vim.lsp.buf_get_clients()) == nil then
        vim.cmd('execute printf("h %s", expand("<cword>"))')
      else
        vim.lsp.buf.hover()
      end
    end

    function definitions()
      if next(vim.lsp.buf_get_clients()) == nil then
        vim.cmd('execute printf("tag %s", expand("<cword>"))')
      else
        vim.cmd('Definitions')
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
    })

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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


      require('lsp-completion').setup()
      -- _G.autocomplete = function()
      --   local col = vim.api.nvim_win_get_cursor(0)[2]
      --   local space_behind_cursor = (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
      --   if not space_behind_cursor then
      --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<c-x><c-o>", true, true, true))
      --   end
      -- end

      -- vim.api.nvim_exec([[
      --   augroup autocompletion
      --     autocmd! * <buffer>
      --     autocmd CursorHoldI <buffer> lua autocomplete()
      --   augroup END
      -- ]], true)

      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K'    , '<cmd>lua hover()<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-]>', '<cmd>lua definitions()<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-R>', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-}>', ':TypeDefinitions<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-c>', ':CodeActions<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-r>', ':References<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-w>', ':DocumentSymbols<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-W>', ':WorkspaceSymbols<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-d>', ':Diagnostics<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<a-D>', ':DiagnosticsAll<cr>', {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-space>', '\\<c-x>\\<c-o>', {noremap = true, silent = true, expr = true})
    end

    lsp.bashls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.jsonls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end,
    })

    lsp.cssls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end,
    })

    lsp.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.tsserver.setup({
      capabilities = capabilities,
      on_attach = function(client)
        if client.config.flags then
          client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
      end,
    })

    lsp.ocamllsp.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.graphql.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.texlab.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.zls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp.ccls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local eslint_with_prettier = {
      lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
      lintStdin = true,
      lintFormats = {"%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m"},
      lintIgnoreExitCode = true,
      formatCommand = "eslint_d -f visualstudio --fix-to-stdout --stdin --stdin-filename=${INPUT}",
      formatStdin = true,
    }

    local prettier = {
      lintIgnoreExitCode = true,
      formatCommand = "npx prettier --stdin-filepath ${INPUT}",
      formatStdin = true,
    }

    lsp.efm.setup({
      root_dir = function()
        return vim.fn.getcwd()
      end,
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.goto_definition = false
        on_attach(client)
      end,
      filetypes = {
        "javascript",
        "javascriptreact",
        "json",
        "typescript",
        "typescriptreact",
      },
      settings = {
        languages = {
          javascript = {eslint_with_prettier},
          javascriptreact = {eslint_with_prettier},
          json = {prettier},
          typescript = {prettier},
          typescriptreact = {eslint_with_prettier},
        }
      },
    })

    -- Theming
    vim.cmd('highlight LspDiagnosticsDefaultInformation   guifg=#bbc2cf guibg=NONE    gui=NONE')
    vim.cmd('highlight LspDiagnosticsUnderlineInformation guifg=#3f444a guibg=#bbc2cf gui=NONE')
    vim.cmd('highlight LspDiagnosticsDefaultHint          guifg=#46d9ff guibg=NONE    gui=NONE')
    vim.cmd('highlight LspDiagnosticsUnderlineHint        guifg=#282c34 guibg=#46d9ff gui=NONE')
    vim.cmd('highlight LspDiagnosticsDefaultWarning       guifg=#da8548 guibg=NONE    gui=NONE')
    vim.cmd('highlight LspDiagnosticsUnderlineWarning     guifg=#282c34 guibg=#da8548 gui=NONE')
    vim.cmd('highlight LspDiagnosticsDefaultError         guifg=#ff6c6b guibg=NONE    gui=NONE')
    vim.cmd('highlight LspDiagnosticsUnderlineError       guifg=#282c34 guibg=#ff6c6b gui=NONE')
  end
})

-- LSP + FZF
use_plugin({
  'gfanto/fzf-lsp.nvim',
  config = function()
    require('fzf_lsp').setup()
  end
})

-- Tree-sitter
use_plugin({
  'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'bash',
        'css',
        'graphql',
        'html',
        'javascript',
        'json',
        'latex',
        'lua',
        'ocaml',
        'php',
        'rust',
        'toml',
        'tsx',
        'typescript',
        'zig',
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<a-v>',
          node_incremental = '<a-v>',
          node_decremental = '<a-V>',
        },
      },
    })
  end
})

-- Mapping

vim.api.nvim_set_keymap('n', '<a-e>', ':Explore<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<a-/>', ':Lines<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<tab>', 'pumvisible() ? "\\<c-n>" : "\\<tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'pumvisible() ? "\\<c-p>" : "\\<s-tab>"', {noremap = true, silent = true, expr = true})
vim.api.nvim_set_keymap('n', '<a-m>', ':Himalaya<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<a-t>', ':Unfog<cr>', {noremap = true, silent = true})

-- Config
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.o.background = 'dark'
vim.o.clipboard = 'unnamedplus'
vim.o.completefunc = 'grepletion#completefunc'
vim.o.completeopt = 'menuone,noselect'
vim.o.expandtab = true
vim.o.foldlevelstart = 99
vim.o.runtimepath = vim.o.runtimepath..',~/Code/himalaya/vim'
vim.o.runtimepath = vim.o.runtimepath..',~/Code/unfog.vim'
vim.o.hidden = true
vim.o.pumheight = 12
vim.o.ruler = false
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
vim.wo.signcolumn = 'yes'

-- Theming
vim.cmd([[syntax on
highlight Boolean        guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Character      guifg=#98be65 guibg=NONE    gui=NONE
highlight Comment        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Conditional    guifg=#51afef guibg=NONE    gui=NONE
highlight Constant       guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight CursorLine     guifg=NONE    guibg=#21242b gui=NONE
highlight CursorLineNr   guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Define         guifg=#51afef guibg=NONE    gui=NONE
highlight Delimiter      guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Directory      guifg=#51afef guibg=NONE    gui=bold
highlight Error          guifg=#ff6c6b guibg=NONE    gui=bold
highlight ErrorMsg       guifg=#ff6c6b guibg=NONE    gui=bold
highlight Exception      guifg=#51afef guibg=NONE    gui=NONE
highlight Float          guifg=#bbc2cf guibg=NONE    gui=NONE
highlight FoldColumn     guifg=NONE    guibg=NONE    gui=NONE
highlight Folded         guifg=#5b6268 guibg=NONE    gui=NONE
highlight Function       guifg=#c678dd guibg=NONE    gui=NONE
highlight Identifier     guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight IncSearch      guifg=#282c34 guibg=#ecbe7b gui=NONE
highlight Include        guifg=#51afef guibg=NONE    gui=NONE
highlight Keyword        guifg=#51afef guibg=NONE    gui=NONE
highlight Label          guifg=#51afef guibg=NONE    gui=NONE
highlight LineNr         guifg=#5b6268 guibg=NONE    gui=NONE
highlight MatchParen     guifg=#ff6c6b guibg=#21242b gui=bold
highlight NonText        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Normal         guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Number         guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Operator       guifg=#51afef guibg=NONE    gui=NONE
highlight Pmenu          guifg=#bbc2cf guibg=#21242b gui=NONE
highlight PmenuSel       guifg=#bbc2cf guibg=#2257a0 gui=NONE
highlight PreProc        guifg=#51afef guibg=NONE    gui=NONE
highlight Repeat         guifg=#51afef guibg=NONE    gui=NONE
highlight Search         guifg=#282c34 guibg=#ecbe7b gui=NONE
highlight SignColumn     guifg=#5b6268 guibg=NONE    gui=NONE
highlight Special        guifg=#bbc2cf guibg=NONE    gui=NONE
highlight SpecialComment guifg=#5b6268 guibg=NONE    gui=italic
highlight Statement      guifg=#51afef guibg=NONE    gui=NONE
highlight StatusLine     guifg=#bbc2cf guibg=#21242b gui=NONE
highlight StatusLineNC   guifg=#5b6268 guibg=#21242b gui=NONE
highlight StorageClass   guifg=#51afef guibg=NONE    gui=NONE
highlight String         guifg=#98be65 guibg=NONE    gui=NONE
highlight Structure      guifg=#51afef guibg=NONE    gui=NONE
highlight Success        guifg=#98be65 guibg=NONE    gui=NONE
highlight TabLine        guifg=#bbc2cf guibg=#282c34 gui=NONE
highlight TabLineFill    guifg=#bbc2cf guibg=#23272e gui=NONE
highlight TabLineSel     guifg=#282c34 guibg=#c678dd gui=NONE
highlight Tag            guifg=#c678dd guibg=NONE    gui=NONE
highlight Title          guifg=#c678dd guibg=NONE    gui=NONE
highlight Type           guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Typedef        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight VertSplit      guifg=#3f444a guibg=NONE    gui=NONE
highlight Visual         guifg=NONE    guibg=#3f444a gui=NONE
highlight mailURL        guifg=#51afef guibg=NONE    gui=NONE
]])

  -- Completion
  -- use({
  --   'hrsh7th/nvim-cmp',
  --   requires = 'SirVer/ultisnips',
  --   commit = '5bed2dc',
  --   config = function()
  --     local cmp = require('cmp')
  --     local cmp_keymap = require('cmp.utils.keymap')

  --     cmp.setup({
  --       snippet = {
  --         expand = function(args)
  --           vim.fn['UltiSnips#Anon'](args.body)
  --         end,
  --       },
  --       mapping = {
  --         ['<s-tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
  --         ['<tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
  --         ['<cr>'] = cmp.mapping(function(fallback)
  --           if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
  --             vim.fn.feedkeys(cmp_keymap.t('<c-r>=UltiSnips#JumpForwards()<cr>'))
  --           elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
  --             vim.fn.feedkeys(cmp_keymap.t('<c-r>=UltiSnips#ExpandSnippet()<cr>'))
  --           elseif vim.fn.pumvisible() == 1 and vim.fn.complete_info()["selected"] > -1 then
  --             cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
  --           else
  --             fallback()
  --           end
  --         end, {'i', 's'}),
  --       },
  --       sources = {
  --         {name = 'nvim_lsp'},
  --         {name = 'nvim_lua'},
  --         {name = 'ultisnips'},
  --         {name = 'path'},
  --         {name = 'buffer'},
  --       },
  --     })
  --   end,
  -- })
  -- use({'quangnguyen30192/cmp-nvim-ultisnips', requires = 'hrsh7th/nvim-cmp'})
  -- use({'hrsh7th/cmp-nvim-lsp', requires = 'hrsh7th/nvim-cmp'})
  -- use({'hrsh7th/cmp-nvim-lua', requires = 'hrsh7th/nvim-cmp'})
  -- use({'hrsh7th/cmp-path', requires = 'hrsh7th/nvim-cmp'})
  -- use({'hrsh7th/cmp-buffer', requires = 'hrsh7th/nvim-cmp'})


-- end)

