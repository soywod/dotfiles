" ------------------------------------------------------------------- # Plugin #

call plug#begin()

" LSC
Plug 'natebosch/vim-lsc'

" Fuzzy finder
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'

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

function! FoldText()
  return getline(v:foldstart) . ' '
endfunction

function! InsertEnter()
  highlight StatusLine guifg=#fafafa guibg=#4078f2
endfunction

function! Save()
  if &buftype != 'nofile' && &ro == 0 | :write | endif
  highlight StatusLine guifg=#494B53 guibg=#f0f0f0
endfunction

function! StatusLineCounters()
  let l:qflen = len(getqflist())
  let l:loclen = len(getloclist('%'))
  return ' | qf:' . l:qflen . ' | loc:' . l:loclen . ' '
endfunction

function! ToggleLocList()
  if (getloclist('.') != [])
    if (filter(getwininfo(), 'v:val.loclist') == [])
      lopen
    else
      lclose
    endif
  endif
endfunction

function! ToggleQfList()
  if (filter(getwininfo(), 'v:val.quickfix') == [])
    copen
  else
    cclose
  endif
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
set foldtext=FoldText()
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
autocmd InsertEnter * call InsertEnter()
autocmd InsertLeave,TextChanged * call Save()

command! -nargs=* Search call s:Search(<q-args>)
command! -bang -nargs=* Find call fzf#vim#grep(
  \'rg --column --line-number --no-heading --fixed-strings --ignore-case ' .
  \'--hidden --follow --color "always" --glob "!.git/*" ' .
  \shellescape(<q-args>), 1, <bang>0
\)

" ------------------------------------------------------------------ # Mapping #

let mapleader = ' '

nnoremap <silent> <leader>n :Explore<CR>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>

nnoremap <leader>f :Files<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>h :History<cr>

nnoremap <silent> <leader>c :call ToggleQfList()<cr>
nnoremap <silent> <leader>l :call ToggleLocList()<cr>

