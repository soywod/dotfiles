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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kopischke/vim-stay'
Plug 'soywod/phonetics.vim'
Plug 'soywod/keepeye.vim'
" Plug 'soywod/kronos.vim'

" Theme and syntax
Plug 'sheerun/vim-polyglot'
Plug 'soywod/typescript.vim'

call plug#end()

" ----------------------------------------------------------------- # Function #

function! s:InsertEnter()
  highlight StatusLine guibg=#4078f2 guifg=#fafafa gui=None
endfunction

function! s:Save()
  if &buftype != 'nofile' && ! &ro && ! empty(@%) | :write | endif
  highlight StatusLine guibg=#494b53 guifg=#fafafa gui=None
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
set cursorline
set expandtab
set foldcolumn=2
set foldlevelstart=99
set foldmethod=syntax
set foldtext=getline(v:foldstart)
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

highlight Normal       guibg=#fafafa  guifg=#494b53  gui=None
highlight Visual       guibg=#e0e0e0  guifg=None     gui=None
highlight WildMenu     guibg=#e0e0e0  guifg=None     gui=None
highlight Comment      guibg=None     guifg=#a0a1a7  gui=None
highlight Constant     guibg=None     guifg=#0184bc  gui=None
highlight Boolean      guibg=None     guifg=#c18401  gui=None
highlight String       guibg=None     guifg=#50a14f  gui=None
highlight Character    guibg=None     guifg=#50a14f  gui=None
highlight Identifier   guibg=None     guifg=#e45649  gui=None
highlight Number       guibg=None     guifg=#e45649  gui=None
highlight Keyword      guibg=None     guifg=None     gui=None
highlight Statement    guibg=None     guifg=None     gui=None
highlight PreProc      guibg=None     guifg=#c18401  gui=None
highlight Type         guibg=None     guifg=#c18401  gui=None
highlight NonText      guibg=None     guifg=#d3d3d3  gui=None
highlight Error        guibg=#e45649  guifg=#fafafa  gui=None
highlight ErrorMsg     guibg=None     guifg=#e45649  gui=Bold
highlight Warning      guibg=#c18401  guifg=#fafafa  gui=None
highlight WarningMsg   guibg=None     guifg=#c18401  gui=Bold
highlight CursorLine   guibg=#f4f4f4  guifg=None     gui=None
highlight Underlined   guibg=None     guifg=None     gui=Underline
highlight Ignore       guibg=None     guifg=None     gui=None
highlight Todo         guibg=#0184bc  guifg=#fafafa  gui=Bold
highlight Special      guibg=None     guifg=#0184bc  gui=None
highlight SpecialKey   guibg=None     guifg=#4078f2  gui=None
highlight Directory    guibg=None     guifg=#4078f2  gui=None
highlight Folded       guibg=None     guifg=#d3d3d3  gui=None
highlight FoldColumn   guibg=None     guifg=#e0e0e0  gui=None
highlight SignColumn   guibg=None     guifg=#e0e0e0  gui=None
highlight StatusLine   guibg=#494b53  guifg=#fafafa  gui=None
highlight StatusLineNC guibg=#e0e0e0  guifg=#494B53  gui=None
highlight IncSearch    guibg=#986801  guifg=#fafafa  gui=Bold
highlight Search       guibg=#986801  guifg=#fafafa  gui=Bold
highlight VertSplit    guibg=None     guifg=#f0f0f0  gui=None
highlight Pmenu        guibg=#e0e0e0  guifg=None     gui=None
highlight PmenuSel     guibg=#494b53  guifg=#fafafa  gui=None
highlight SpellBad     guibg=None     guifg=#e45649  gui=Underline
highlight SpellCap     guibg=None     guifg=#c18401  gui=Underline
highlight User1        guibg=#e45649  guifg=#fafafa  gui=Bold
highlight LineNr       guibg=None     guifg=#e0e0e0  gui=None
highlight Function     guibg=None     guifg=#4078f2  gui=None

highlight link jsFuncCall     Function
highlight link jsStorageClass Statement

highlight link xmlAttrib      None
highlight link xmlEndTag      Identifier
highlight link xmlTag         None
highlight link xmlTagName     Identifier

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
nnoremap <silent> <a-/> :noh<cr>

nnoremap <c-space> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>

nnoremap <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
