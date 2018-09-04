" ------------------------------------------------------------------- # Plugin #

call plug#begin()

" Language Server Protocol
Plug 'natebosch/vim-lsc'

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Utilities
Plug 'mattn/emmet-vim'
Plug 'shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'ervandew/supertab'
" Plug 'junegunn/vader.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kopischke/vim-stay'
Plug 'soywod/phonetics.vim'
Plug 'soywod/keepeye.vim'
" Plug 'soywod/mpc.vim'
" Plug 'soywod/kronos.vim'
" Plug 'soywod/hermes.vim'
" Plug 'vim-vdebug/vdebug'

" Theme and syntax
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'soywod/typescript.vim'

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

function! ToggleLocList()
  let locempty = empty(getloclist('.'))
  if  locempty | call setloclist(0, []) | endif

  let locopen  = filter(getwininfo(), 'v:val.loclist') == []
  if  locopen  | lopen | else | lclose  | endif
endfunction

function! ToggleQfList()
  let qfopen = filter(getwininfo(), 'v:val.quickfix') == []
  if  qfopen | copen | else | cclose | endif
endfunction

" ------------------------------------------------------------------ # Setting #

set background=light
set backspace=indent,eol,start
set backupcopy=yes
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
set nowritebackup
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
highlight StatusLine   guifg=#494B53 guibg=#f0f0f0
highlight StatusLineNC guifg=#f0f0f0 guibg=#f0f0f0
highlight User1        guibg=#e45649 guifg=#fafafa
highlight xmlAttrib    guifg=#0184bc
highlight xmlEndTag    guifg=#d3d3d3
highlight xmlTag       guifg=#494B53

" -------------------------------------------------------------- # Plugin conf #

let g:deoplete#enable_at_startup = 1
let g:jsx_ext_required = 1

let g:lsc_auto_map = v:true
let g:lsc_preview_split_direction = 'below'
let g:lsc_server_commands = {
  \'javascript':      'node_modules/.bin/javascript-typescript-stdio',
  \'javascript.jsx':  'node_modules/.bin/javascript-typescript-stdio',
  \'typescript':      'node_modules/.bin/javascript-typescript-stdio',
  \'typescript.tsx':  'node_modules/.bin/javascript-typescript-stdio',
\}

let g:polyglot_disabled = ['typescript']

let g:mpc_host = '/run/user/$UID/mpd.sock'
let g:neocomplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

let g:emmet_html5 = 0
let g:user_emmet_mode = 'i'
let g:user_emmet_leader_key = ','

let g:keepeye_features = ['notification']
let g:keepeye_message = "Va t'étirer, gros sac !"

let g:kronos_gist_sync = 1

let g:vdebug_options = {
  \'port' : 9000,
  \'server' : '0.0.0.0',
  \'timeout' : 20,
  \'on_close' : 'detach',
  \'break_on_open' : 0,
  \'ide_key' : 'VIM',
  \'path_maps' : {
    \'/var/www/html/': '/home/soywod/Code/javottes/',
  \},
  \'debug_window_level' : 0,
  \'debug_file_level' : 0,
  \'debug_file' : '',
  \'watch_window_style' : 'expanded',
\}

" ------------------------------------------------------------------ # Command #

autocmd FileType qf wincmd J
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd InsertEnter * call s:InsertEnter()
autocmd InsertLeave,TextChanged * call s:Save()

command! -nargs=* Find call s:Find(<q-args>)
command! -nargs=* Grep call s:Grep(<q-args>)

command! -bang -nargs=* Grep call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" --glob "!.git/*" ' . shellescape(<q-args>), 1, <bang>0)

" ------------------------------------------------------------------ # Mapping #

nnoremap <silent> <a-n> :Explore<cr>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>
nnoremap <silent> <c-c> :bdelete<cr>

nnoremap <silent> <c-p> :cprev<cr>
nnoremap <silent> <c-n> :cnext<cr>

nnoremap <silent> <a-l> :call ToggleLocList()<cr>
nnoremap <silent> <a-c> :call ToggleQfList()<cr>
" nnoremap <silent> <a-t> :Kronos<cr>
nnoremap <silent> <a-p> :PhoneticsPlay<cr>

nnoremap <c-space> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>

" nnoremap <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>

