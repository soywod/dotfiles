set nocompatible

call plug#begin()

" Completion engine
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-neco', {'for': 'vim'}
" Plug 'shougo/neco-vim'  , {'for': 'vim'}
" Plug 'junegunn/fzf'     , {'dir': '~/.fzf', 'do': './install --all'}
" Plug 'junegunn/fzf.vim'

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'

" Completion
Plug 'nvim-lua/completion-nvim'
" Plug 'hrsh7th/nvim-compe'

" Snippets
Plug 'norcalli/snippets.nvim'
" Plug 'sirver/ultisnips'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'


" Utilities
Plug 'norcalli/nvim-colorizer.lua'
Plug 'jamessan/vim-gnupg'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'

Plug 'soywod/quicklist.vim', {'dir': '~/Code/quicklist.vim'}
Plug 'soywod/unfog.vim', {'dir': '~/Code/unfog.vim'}
Plug 'soywod/himalaya', {'dir': '~/Code/himalaya', 'rtp': 'vim'}
Plug 'soywod/bufmark.vim', {'dir': '~/Code/bufmark.vim'}

" Theme and syntax
Plug 'arcticicestudio/nord-vim'
" Plug 'elzr/vim-json'                    , {'for': 'json'}
" Plug 'othree/html5.vim'                 , {'for': 'html'}
" Plug 'hail2u/vim-css3-syntax'           , {'for': 'css'}
" Plug 'plasticboy/vim-markdown'          , {'for': 'markdown'}
" Plug 'pangloss/vim-javascript'          , {'for': ['javascript', 'javascript.jsx']}
" Plug 'mxw/vim-jsx'                      , {'for': ['javascript', 'javascript.jsx']}
" Plug 'soywod/typescript.vim'            , {'for': ['typescript', 'typescript.jsx']}
" Plug 'vim-ruby/vim-ruby'                , {'for': ['ruby']}
" Plug 'rust-lang/rust.vim'               , {'for': 'rust'}
" Plug 'digitaltoad/vim-pug'              , {'for': 'pug'}
" Plug 'ElmCast/elm-vim'                  , {'for': 'elm'}
" Plug 'neovimhaskell/haskell-vim'        , {'for': 'haskell'}
" Plug 'purescript-contrib/purescript-vim', {'for': 'purescript'}
" Plug 'ocaml/vim-ocaml'                  , {'for': 'ocaml'}
" Plug 'cespare/vim-toml'                 , {'for': 'toml'}
" Plug 'ledger/vim-ledger'                , {'for': 'ledger'}
" Plug 'dart-lang/dart-vim-plugin'        , {'for': 'dart'}

call plug#end()

set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set foldmethod=expr
set ttimeoutlen=50

set viewoptions=cursor,folds,slash,unix
set wildmenu

colorscheme nord

highlight LspDiagnosticsUnderlineError    guibg=#bf616a guifg=#d8dee9 gui=None
highlight LspDiagnosticsUnderlineWarning  guibg=#ebcb8b guifg=#3b4252 gui=None
highlight LspDiagnosticsUnderlineHint     guibg=#b48ead guifg=#3b4252 gui=None
highlight LspDiagnosticsUnderlineInfo     guibg=#b48ead guifg=#3b4252 gui=None

highlight LspDiagnosticsFloatingError   guibg=None
highlight LspDiagnosticsFloatingWarning guibg=None
highlight LspDiagnosticsFloatingHint    guibg=None

highlight Error               guibg=#bf616a guifg=#d8dee9 gui=None
highlight ErrorMsg            guibg=None    guifg=#bf616a gui=Bold
highlight Folded              guibg=None    guifg=#4c566a gui=None
highlight MatchParen          guibg=None    guifg=#88c0d0 gui=Bold,Underline
highlight Search              guibg=#d08770 guifg=#eceff4 gui=None
highlight Warning             guibg=#ebcb8b guifg=#3b4252 gui=None
highlight WarningMsg          guibg=None    guifg=#ebcb8b gui=Bold
highlight Comment             guibg=None    guifg=#4c566a gui=None
highlight StatusLine          guibg=#3b4252 guifg=#d8dee9 gui=None
highlight StatusLineNC        guibg=#3b4252 guifg=#d8dee9 gui=None
highlight CursorLineNr        guibg=None    guifg=#ebcb8b gui=None
highlight TabLine             guibg=#2e3440 guifg=#d8dee9 gui=None
highlight TabLineFill         guibg=#2e3440 guifg=#d8dee9 gui=None
highlight TabLineSel          guibg=#d8dee9 guifg=#2e3440 gui=None

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF

lua << EOF
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

local nvim_lsp = require('lspconfig')

local capabilities = lsp_status.capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true;

local on_attach = function(client)
  require'snippets'.use_suggested_mappings()
  require'completion'.on_attach(client)
  lsp_status.on_attach(client)
end

local servers = { "tsserver", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { 
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

require'snippets'.snippets = {
  _global = {
    coucou = "COUCOU",
  }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = false,
  }
)

-- do
--   local method = "textDocument/publishDiagnostics"
--   local default_handler = vim.lsp.handlers[method]
--   vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
--     default_handler(err, method, result, client_id, bufnr, config)
--     local diagnostics = vim.lsp.diagnostic.get_all()
--     local qflist = {}
--     for bufnr, diagnostic in pairs(diagnostics) do
--       for _, d in ipairs(diagnostic) do
--         d.bufnr = bufnr
--         d.lnum = d.range.start.line + 1
--         d.col = d.range.start.character + 1
--         d.text = d.message
--         table.insert(qflist, d)
--       end
--     end
--     vim.lsp.util.set_qflist(qflist)
--   end
-- end

EOF

" lua << EOF
" require'compe'.setup {
"   enabled = true;
"   autocomplete = true;
"   debug = false;
"   min_length = 1;
"   preselect = 'enable';
"   throttle_time = 80;
"   source_timeout = 200;
"   incomplete_delay = 400;
"   max_abbr_width = 100;
"   max_kind_width = 100;
"   max_menu_width = 100;
"   documentation = true;

"   source = {
"     path = true;
"     buffer = true;
"     calc = true;
"     nvim_lsp = true;
"     nvim_lua = true;
"     vsnip = true;
"   };
" }
" EOF

lua << EOF
EOF

lua require'colorizer'.setup()

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

set statusline=%m%r%y%{LspStatus()}


" ------------------------------------------------------------- # Plugins conf #

let g:completion_enable_snippet = 'snippets.nvim'
let g:completion_matching_strategy_list = ['fuzzy', 'exact', 'substring']
let g:completion_timer_cycle = 300
" let g:ledger_default_commodity = '€'

" ---------------------------------------------------------------- # Functions #

function! s:run()
  :w

  if &filetype == 'rust'
    :!cargo run -q
  else
    :!%:p
  endif
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute printf('h %s', expand('<cword>'))
  else
    call CocAction('doHover')
  endif
endfunction

function! s:grep(args, bang)
  let args = [
    \'--column',
    \'--line-number',
    \'--no-heading',
    \'--fixed-strings',
    \'--ignore-case',
    \'--hidden',
    \'--follow',
    \'--color "always"',
    \'--glob "!.git/*"',
    \shellescape(a:args),
  \]

  call fzf#vim#grep(printf('rg %s', join(args, ' ')), 1, a:bang)
endfunction

fun s:ledger_align()
  let prev_pos = getpos(".")
  %LedgerAlign
  call setpos('.', prev_pos)
endfun

" ----------------------------------------------------------------- # Commands #

command! -bang -nargs=* Grep call s:grep(<q-args>, <bang>0)

augroup dotfiles
  autocmd!
  " autocmd CursorHold  *   silent call CocActionAsync('highlight')
  autocmd FileType    *   setlocal fo-=c fo-=r fo-=o
  autocmd FileType    qf  wincmd J
  autocmd FileType    ledger autocmd! BufWritePre * call s:ledger_align()
  autocmd BufEnter    * lua require'completion'.on_attach()
  " autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
augroup end

" ----------------------------------------------------------------- # Mappings #

function! s:show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute printf('h %s', expand('<cword>'))
  else
    lua vim.lsp.buf.hover()
  endif
endfunction
" lua <<EOF
" local previewers = require('telescope.previewers')
" local pickers = require('telescope.pickers')
" local sorters = require('telescope.sorters')
" local finders = require('telescope.finders')

" pickers.new {
"   results_title = 'Resources',
"   -- Run an external command and show the results in the finder window
"   finder = finders.new_oneshot_job({'terraform', 'show'}),
"   sorter = sorters.get_fuzzy_file(),
"   previewer = previewers.new_termopen_previewer {
"     -- Execute another command using the highlighted entry
"     get_command = function(entry)
"       return {'terraform', 'state', 'list', entry.value}
"     end
"   },
" }:find()
" EOF

" nnoremap  <silent>  <a-n> :Explore<cr>
" nnoremap  <silent>  <c-c> :bwipeout<cr>
" nnoremap  <silent>  <a-/> :noh<cr>
" nmap      <silent>  <a-d> <plug>(coc-definition)
" nmap      <silent>  <a-r> <plug>(coc-references)
" nnoremap  <silent>  <a-f> :call fzf#vim#files({})<cr>
nnoremap  <silent>  <a-f> :Telescope find_files<cr>
" vnoremap  <silent>  <a-s> :'<,'>sort<cr>
" nnoremap  <silent>  K     :call <sid>show_documentation()<cr>
" inoremap  <a-f>  <Plug>(coc-fix-current)

" nmap      <a-R> <plug>(coc-rename)
" nmap      <a-a> <plug>(coc-codeaction)
nnoremap  <a-t> :Unfog<cr>
nnoremap  <a-m> :Himalaya<cr>
nnoremap  <a-g> :Telescope live_grep<cr> 
nnoremap  <a-h> :Telescope oldfiles<cr>
nnoremap  <a-b> :Telescope buffers<cr>
" inoremap <cr> <Cmd>lua return require'snippets'.expand_or_advance(1)<CR>

nnoremap <silent> K     :call <sid>show_documentation()<cr>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<cr>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<cr>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> <c-h> <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> <c-l> <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" nnoremap  <a-e> :call <sid>run()<cr>
" nnoremap  <a-s> :Explore ~/.dotfiles/neovim/snippets<cr>
" vnoremap  .     :normal .<cr>
" vnoremap  Y     y`]
" nnoremap  <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
" nmap      <a-s> <plug>(coc-format-selected)

" inoremap <silent> <expr> <c-space> coc#refresh()
" inoremap <silent> <expr> <tab>     pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent> <expr> <s-tab>   pumvisible() ? "\<c-p>" : "\<s-tab>"
" inoremap <silent> <expr> <cr>      pumvisible() ? coc#_select_confirm() : "\<cr>"
