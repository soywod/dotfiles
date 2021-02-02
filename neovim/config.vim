set nocompatible

" ------------------------------------------------------------------ # Plugins #

call plug#begin()

" Completion engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-neco', {'for': 'vim'}
Plug 'shougo/neco-vim'  , {'for': 'vim'}

Plug 'junegunn/fzf'     , {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Utilities
Plug 'jamessan/vim-gnupg'
Plug 'mattn/emmet-vim'
Plug 'sirver/ultisnips'
Plug 'soywod/quicklist.vim'
Plug 'soywod/unfog.vim'
Plug 'soywod/himalaya.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Theme and syntax
Plug 'arcticicestudio/nord-vim'
Plug 'elzr/vim-json'                    , {'for': 'json'}
Plug 'othree/html5.vim'                 , {'for': 'html'}
Plug 'hail2u/vim-css3-syntax'           , {'for': 'css'}
Plug 'plasticboy/vim-markdown'          , {'for': 'markdown'}
Plug 'pangloss/vim-javascript'          , {'for': ['javascript', 'javascript.jsx']}
Plug 'mxw/vim-jsx'                      , {'for': ['javascript', 'javascript.jsx']}
Plug 'soywod/typescript.vim'            , {'for': ['typescript', 'typescript.jsx']}
Plug 'vim-ruby/vim-ruby'                , {'for': ['ruby']}
Plug 'rust-lang/rust.vim'               , {'for': 'rust'}
Plug 'digitaltoad/vim-pug'              , {'for': 'pug'}
Plug 'ElmCast/elm-vim'                  , {'for': 'elm'}
Plug 'neovimhaskell/haskell-vim'        , {'for': 'haskell'}
Plug 'purescript-contrib/purescript-vim', {'for': 'purescript'}
Plug 'ocaml/vim-ocaml'                  , {'for': 'ocaml'}
Plug 'cespare/vim-toml'                 , {'for': 'toml'}
Plug 'ledger/vim-ledger'                , {'for': 'ledger'}
Plug 'dart-lang/dart-vim-plugin'        , {'for': 'dart'}

call plug#end()

" ----------------------------------------------------------------- # Settings #

set autoindent
set background=dark
set backspace=indent,eol,start
set breakindent
set clipboard=unnamedplus
set cmdheight=3
set completeopt=noinsert,menuone,noselect
set cursorline
set expandtab
set foldlevelstart=99
set foldmethod=syntax
" set foldtext=getline(v:foldstart)
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
set undodir=~/.config/nvim/undo//
set undofile
set updatetime=300
set viewoptions=cursor,folds,slash,unix
set wildmenu

" -------------------------------------------------------------------- # Theme #

colorscheme nord

highlight Error               guibg=#bf616a guifg=#d8dee9 gui=NONE
highlight ErrorMsg            guibg=NONE    guifg=#bf616a gui=Bold
highlight CocErrorHighlight   guibg=#bf616a guifg=#d8dee9 gui=NONE
highlight CocErrorSign        guibg=#bf616a guifg=#d8dee9 gui=NONE
highlight Warning             guibg=#ebcb8b guifg=#d8dee9 gui=NONE
highlight WarningMsg          guibg=NONE    guifg=#ebcb8b gui=Bold
highlight CocWarningHighlight guibg=#ebcb8b guifg=#616e88 gui=NONE
highlight CocWarningSign      guibg=#ebcb8b guifg=#616e88 gui=NONE

" ------------------------------------------------------------- # Plugins conf #

let g:UltiSnipsExpandTrigger = '<m-cr>'
let g:UltiSnipsJumpForwardTrigger = '<cr>'

let g:user_emmet_leader_key = ','
let g:user_emmet_mode = 'a'
let g:user_emmet_install_global = 0

let g:fzf_layout = {'down': '~40%'}

let g:ledger_default_commodity = '€'

" Netrw

let g:netrw_compress = "pack"
let g:netrw_decompress = {
  \".zip": "7z x" ,
  \".tar": "tar -xf",
  \".tar.gz": "tar -xzf",
  \".gz": "gzip -d",
\}


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
  autocmd CursorHold  *   silent call CocActionAsync('highlight')
  autocmd FileType    *   setlocal fo-=c fo-=r fo-=o
  autocmd FileType    qf  wincmd J
  autocmd FileType    html,css,scss,less,javascript*,typescript*,php  EmmetInstall
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
nmap      <a-a> <Plug>(coc-codeaction)
nnoremap  <a-t> :Unfog<cr>
nnoremap  <a-m> :Iris<cr>
nnoremap  <a-M> :IrisFolder<cr>
nnoremap  <a-g> :Grep 
nnoremap  <a-h> :History<cr>
nnoremap  <a-b> :Buffers<cr>
nnoremap  <a-e> :call <sid>run()<cr>
vnoremap  .     :normal .<cr>
vnoremap  Y     y`]
" nnoremap  <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
" nmap      <a-s> <plug>(coc-format-selected)

inoremap  <expr> <c-j>    pumvisible() ? "\<c-y>" : "\<c-g>u\<c-j>"
inoremap  <expr> <tab>    pumvisible() ? "\<c-n>" : "\<tab>"
inoremap  <expr> <s-tab>  pumvisible() ? "\<c-p>" : "\<s-tab>"

inoremap  <silent> <expr> <c-space>  coc#refresh()
xnoremap  Q :'<,'>:normal @q<cr>
