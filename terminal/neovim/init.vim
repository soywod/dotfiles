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
Plug 'soywod/kronos.vim'

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

highlight Normal       guibg=#fafafa  guifg=#494b53  gui=NONE
highlight Visual       guibg=#e0e0e0  guifg=NONE     gui=NONE
highlight WildMenu     guibg=#e0e0e0  guifg=NONE     gui=NONE
highlight Comment      guibg=NONE     guifg=#a0a1a7  gui=NONE
highlight Constant     guibg=NONE     guifg=#0184bc  gui=NONE
highlight Boolean      guibg=NONE     guifg=#c18401  gui=NONE
highlight String       guibg=NONE     guifg=#50a14f  gui=NONE
highlight Character    guibg=NONE     guifg=#50a14f  gui=NONE
highlight Identifier   guibg=NONE     guifg=#e45649  gui=NONE
highlight Number       guibg=NONE     guifg=#e45649  gui=NONE
highlight Keyword      guibg=NONE     guifg=NONE     gui=NONE
highlight Statement    guibg=NONE     guifg=NONE     gui=NONE
highlight PreProc      guibg=NONE     guifg=#c18401  gui=NONE
highlight Type         guibg=NONE     guifg=#c18401  gui=NONE
highlight NonText      guibg=NONE     guifg=#d3d3d3  gui=NONE
highlight Error        guibg=#e45649  guifg=#fafafa  gui=NONE
highlight ErrorMsg     guibg=NONE     guifg=#e45649  gui=Bold
highlight Warning      guibg=#c18401  guifg=#fafafa  gui=NONE
highlight WarningMsg   guibg=NONE     guifg=#c18401  gui=Bold
highlight CursorLine   guibg=#f4f4f4  guifg=NONE     gui=NONE
highlight Underlined   guibg=NONE     guifg=NONE     gui=Underline
highlight Ignore       guibg=NONE     guifg=NONE     gui=NONE
highlight Todo         guibg=#0184bc  guifg=#fafafa  gui=Bold
highlight Special      guibg=NONE     guifg=#0184bc  gui=NONE
highlight SpecialKey   guibg=NONE     guifg=#4078f2  gui=NONE
highlight Directory    guibg=NONE     guifg=#4078f2  gui=NONE
highlight Folded       guibg=NONE     guifg=#d3d3d3  gui=NONE
highlight FoldColumn   guibg=NONE     guifg=#e0e0e0  gui=NONE
highlight SignColumn   guibg=NONE     guifg=#e0e0e0  gui=NONE
highlight StatusLine   guibg=#494b53  guifg=#fafafa  gui=NONE
highlight StatusLineNC guibg=#e0e0e0  guifg=#494B53  gui=NONE
highlight IncSearch    guibg=#986801  guifg=#fafafa  gui=Bold
highlight Search       guibg=#986801  guifg=#fafafa  gui=Bold
highlight VertSplit    guibg=NONE     guifg=#f0f0f0  gui=NONE
highlight Pmenu        guibg=#e0e0e0  guifg=NONE     gui=NONE
highlight PmenuSel     guibg=#494b53  guifg=#fafafa  gui=NONE
highlight SpellBad     guibg=NONE     guifg=#e45649  gui=Underline
highlight SpellCap     guibg=NONE     guifg=#c18401  gui=Underline
highlight User1        guibg=#e45649  guifg=#fafafa  gui=Bold
highlight LineNr       guibg=NONE     guifg=#e0e0e0  gui=NONE
highlight Function     guibg=NONE     guifg=#4078f2  gui=NONE

highlight link jsFuncCall     Function
highlight link jsStorageClass Statement

highlight link xmlAttrib      NONE
highlight link xmlEndTag      Identifier
highlight link xmlTag         NONE
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

let g:kronos_sync = 1

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
nnoremap <silent> <a-t> :Kronos<cr>
nnoremap <silent> <a-p> :PhoneticsPlay<cr>
nnoremap <silent> <a-/> :noh<cr>

nnoremap <c-space> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>

nnoremap <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
