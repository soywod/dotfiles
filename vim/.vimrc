" ------------------------------------------------------------------- # Plugin #

call plug#begin()

" LSC
Plug 'natebosch/vim-lsc'

" Fuzzy finder
" Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
" Plug 'junegunn/fzf.vim'
" Plug 'ctrlpvim/ctrlp.vim'

" Utilities
Plug 'mattn/emmet-vim'
Plug 'shougo/neocomplete.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/vader.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kopischke/vim-stay'
Plug 'soywod/kronos.vim'
Plug 'soywod/mpc.vim'
Plug 'soywod/vim-phonetics'

" Theme and syntax
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
" Plug 'herringtondarkholme/yats.vim'
" Plug 'pangloss/vim-javascript'


call plug#end()

" ----------------------------------------------------------------- # Function #

function! s:FoldText()
  return getline(v:foldstart) . ' '
endfunction

function! s:InsertEnter()
  highlight StatusLine guifg=#fafafa guibg=#4078f2
endfunction

function! s:Save()
  if &buftype != 'nofile' && ! &ro && ! empty(@%) | :write | endif
  highlight StatusLine guifg=#494B53 guibg=#f0f0f0
endfunction

function! StatusLineCounters()
  let l:qflen = len(getqflist())
  let l:loclen = len(getloclist('%'))
  return ' | qf:' . l:qflen . ' | loc:' . l:loclen . ' '
endfunction

function! s:Find(opts)
  let cmd = 'find ' . a:opts
  let output = map(systemlist(cmd), 's:FindLine(v:val)')

  call setqflist(output)
  copen
endfunction

function! s:FindLine(filename)
  let text = fnamemodify(a:filename, ':t')

  return {
    \'filename': a:filename,
    \'text': text,
  \}
endfunction

function! s:Grep(opts)
  let cmd = 'grep ' . a:opts
  let output = map(systemlist(cmd), 's:GrepLine(v:val)')

  call setqflist(output)
  copen
endfunction

function! s:GrepLine(line)
  let [filename, lnum; text] = split(a:line, ':')

  return {
    \'filename': filename,
    \'lnum': lnum,
    \'text': join(text, ':'),
  \}
endfunction

" ------------------------------------------------------------------ # Setting #

set background=light
set backspace=indent,eol,start
set breakindent
set clipboard=unnamedplus
set completeopt-=preview
set expandtab
set foldcolumn=2
set foldlevelstart=99
set foldmethod=syntax
set foldtext=s:FoldText()
set hidden
set history=1000
set laststatus=2
set linebreak
set nobackup
set noshowmode
set noswapfile
set ruler
set scrolloff=3
set shiftwidth=2
set smartcase
set softtabstop=2
set splitright
set statusline=\ \:%l,%c
set statusline+=%=%y\ %t
set statusline+=%{StatusLineCounters()}
set tabstop=2
set termguicolors
set ttimeoutlen=50
set viewoptions=cursor,folds,slash,unix

" -------------------------------------------------------------------- # Theme #

colorscheme one

highlight clear FoldColumn
highlight clear SignColumn
highlight FoldColumn   guifg=#d3d3d3
highlight Folded       guibg=#fafafa guifg=#d3d3d3
highlight StatusLineNC guifg=#f0f0f0 guibg=#f0f0f0
highlight StatusLine   guifg=#494B53 guibg=#f0f0f0
highlight User1        guibg=#e45649 guifg=#fafafa

" -------------------------------------------------------------- # Plugin conf #

let g:jsx_ext_required = 1

let g:lsc_auto_map = v:true
let g:lsc_preview_split_direction = 'below'
let g:lsc_server_commands = {
  \'javascript':      'node_modules/.bin/javascript-typescript-stdio',
  \'javascript.jsx':  'node_modules/.bin/javascript-typescript-stdio',
  \'typescript':      'node_modules/.bin/javascript-typescript-stdio',
  \'typescript.tsx':  'node_modules/.bin/javascript-typescript-stdio',
  \'typescriptreact': 'node_modules/.bin/javascript-typescript-stdio',
\}

let g:mpc_host = '/run/user/$UID/mpd.sock'
let g:neocomplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:user_emmet_install_global = 1
let g:user_emmet_leader_key = ','

" ------------------------------------------------------------------ # Command #

autocmd FileType qf wincmd J
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd InsertEnter * call s:InsertEnter()
autocmd InsertLeave,TextChanged * call s:Save()

command! -nargs=* Grep call s:Grep(<q-args>)
command! -nargs=* Find call s:Find(<q-args>)

" ------------------------------------------------------------------ # Mapping #

let mapleader = ' '

nnoremap <silent> <leader>n :Explore<CR>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>
nnoremap <silent> <c-c> :bdelete<cr>

nnoremap <silent> <c-p> :cprev<cr>
nnoremap <silent> <c-n> :cnext<cr>

nnoremap <leader>f :Find -iname 
nnoremap <leader>g :Grep -Inri 

