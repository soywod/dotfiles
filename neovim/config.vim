set nocompatible

" ------------------------------------------------------------------ # Plugins #

call plug#begin()

" Completion engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-neco', {'for': 'vim'}
Plug 'shougo/neco-vim'  , {'for': 'vim'}

Plug 'junegunn/fzf'     , {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Utilities
Plug 'jamessan/vim-gnupg'
Plug 'soywod/quicklist.vim'
Plug 'soywod/unfog.vim'
Plug 'soywod/himalaya.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

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

" lua << EOF 
" require'lspconfig'.sqlls.setup{}
" EOF 

" ----------------------------------------------------------------- # Settings #

set autoindent
set background=dark
set backspace=indent,eol,start
set breakindent
set clipboard=unnamedplus
set cmdheight=3
set completeopt=noinsert,menuone,noselect
set expandtab
set foldlevelstart=99
" set foldmethod=syntax
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set hidden
set history=1000
set laststatus=2
set linebreak
set nobackup
set noswapfile
set nowritebackup
set number
set relativenumber
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=ctT
set smartcase
set softtabstop=2
set splitbelow
set statusline=%<%f\ %h%m%r%=%=%y\ %-14.(%l,%c-%{strwidth(getline('.'))}%)\ %P
set tabstop=2
set termguicolors
set ttimeoutlen=50
set undodir=~/.config/nvim/undo/
set undofile
set updatetime=300
set viewoptions=cursor,folds,slash,unix
set wildmenu

" -------------------------------------------------------------------- # Theme #

colorscheme nord

highlight CocErrorHighlight   guibg=#bf616a guifg=#d8dee9 gui=None
highlight CocErrorSign        guibg=#bf616a guifg=#d8dee9 gui=None
highlight CocWarningHighlight guibg=#ebcb8b guifg=#3b4252 gui=None
highlight CocWarningSign      guibg=None    guifg=#ebcb8b gui=None
highlight Error               guibg=#bf616a guifg=#d8dee9 gui=None
highlight ErrorMsg            guibg=None    guifg=#bf616a gui=Bold
highlight Folded              guibg=None    guifg=#4c566a gui=None
highlight MatchParen          guibg=None    guifg=#88c0d0 gui=Bold,Underline
highlight Search              guibg=#d08770 guifg=#eceff4 gui=None
highlight Warning             guibg=#ebcb8b guifg=#3b4252 gui=None
highlight WarningMsg          guibg=None    guifg=#ebcb8b gui=Bold
highlight Comment             guibg=None    guifg=#4c566a gui=None

" ------------------------------------------------------------- # Plugins conf #

let g:fzf_layout = {'down': '~40%'}
let g:ledger_default_commodity = '€'
let g:AutoPairsShortcutToggle = ''

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
augroup end

" ----------------------------------------------------------------- # Mappings #

nnoremap  <silent>  <a-n> :Explore<cr>
nnoremap  <silent>  <c-c> :bwipeout<cr>
nnoremap  <silent>  <a-/> :noh<cr>
nmap      <silent>  <a-d> <plug>(coc-definition)
nmap      <silent>  <a-r> <plug>(coc-references)
nnoremap  <silent>  <a-f> :call fzf#vim#files({})<cr>
vnoremap  <silent>  <a-s> :'<,'>sort<cr>
nnoremap  <silent>  K     :call <sid>show_documentation()<cr>

nmap      <a-R> <plug>(coc-rename)
nmap      <a-a> <plug>(coc-codeaction)
nnoremap  <a-t> :Unfog<cr>
nnoremap  <a-m> :Himalaya<cr>
nnoremap  <a-g> :Grep 
nnoremap  <a-h> :History<cr>
nnoremap  <a-b> :Buffers<cr>
nnoremap  <a-e> :call <sid>run()<cr>
vnoremap  .     :normal .<cr>
vnoremap  Y     y`]
" nnoremap  <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
" nmap      <a-s> <plug>(coc-format-selected)

inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

inoremap <silent><expr> <a-cr>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
  \ coc#refresh()

let g:coc_snippet_next = '<a-cr>'
