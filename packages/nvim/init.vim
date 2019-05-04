" vim:ft=vim

set nocompatible

" ------------------------------------------------------------------ # Plugins #

call plug#begin()

" Linting, fixing and completion
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Utilities
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'sirver/ultisnips'
Plug 'zhimsel/vim-stay'
Plug 'mattn/emmet-vim'
Plug 'jamessan/vim-gnupg'
Plug 'terryma/vim-expand-region'

" Theme and syntax
Plug 'rakr/vim-one'
Plug 'elzr/vim-json',             {'for': 'json'}
Plug 'othree/html5.vim',          {'for': 'html'}
Plug 'hail2u/vim-css3-syntax',    {'for': 'css'}
Plug 'plasticboy/vim-markdown',   {'for': 'markdown'}
Plug 'pangloss/vim-javascript',   {'for': ['javascript', 'javascript.jsx']}
Plug 'mxw/vim-jsx',               {'for': ['javascript', 'javascript.jsx']}
Plug 'soywod/typescript.vim',     {'for': ['typescript', 'typescript.jsx']}

call plug#end()

" ---------------------------------------------------------------- # Functions #

function! s:toggle_loc_list()
  let locempty = empty(getloclist('.'))
  if  locempty | call setloclist(0, []) | endif

  let locopen  = filter(getwininfo(), 'v:val.loclist') == []
  if  locopen | lopen | else | lclose  | endif
endfunction

function! s:toggle_quick_fix()
  let qfopen = filter(getwininfo(), 'v:val.quickfix') == []
  if  qfopen | copen | else | cclose | endif
endfunction

function! s:preview_opened()
  for buffer in range(1, winnr('$'))
    if getwinvar(buffer, "&previewwindow") == 1
      return 1
    endif  
  endfor

  return 0
endfunction

function s:grep(args, bang)
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

" ------------------------------------------------------------------ # Settings #

set autoindent
set background=light
set backspace=indent,eol,start
set backupcopy=yes
set backupdir=~/.config/nvim/backup//
set breakindent
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set directory=~/.config/nvim/swap//
set expandtab
set foldcolumn=2
set foldlevelstart=99
set foldmethod=syntax
set foldtext=getline(v:foldstart)
set hidden
set history=1000
set laststatus=2
set linebreak
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=ctT
set smartcase
set softtabstop=2
set splitright
set statusline=%<%f\ %h%m%r%=%=%y\ %-14.(%l,%c-%{strwidth(getline('.'))}%)\ %P
set tabstop=2
set termguicolors
set ttimeoutlen=50
set undodir=~/.config/nvim/undo//
set undofile
set viewoptions=cursor,folds,slash,unix
set wildmenu

" -------------------------------------------------------------------- # Theme #

colorscheme one

highlight clear FoldColumn
highlight clear SignColumn

highlight FoldColumn   guifg=#d3d3d3
highlight Folded       guibg=#fafafa guifg=#d3d3d3
highlight StatusLine   guifg=#494B53 guibg=#f0f0f0
highlight StatusLineNC guifg=#f0f0f0 guibg=#f0f0f0

highlight Error        guibg=#e45649  guifg=#fafafa  gui=NONE
highlight ErrorMsg     guibg=NONE     guifg=#e45649  gui=Bold
highlight ALEErrorSign guibg=#e45649  guifg=#fafafa  gui=NONE

highlight Warning        guibg=#c18401  guifg=#fafafa  gui=NONE
highlight WarningMsg     guibg=NONE     guifg=#c18401  gui=Bold
highlight ALEWarningSign guibg=#c18401  guifg=#fafafa  gui=NONE

" ------------------------------------------------------------- # Plugins conf #

let g:UltiSnipsExpandTrigger = '<m-cr>'
let g:UltiSnipsJumpForwardTrigger = '<cr>'

let g:user_emmet_leader_key = ','
let g:user_emmet_mode = 'a'
let g:user_emmet_install_global = 0

let g:deoplete#enable_at_startup = 1

let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1

let ale_linters = {
  \'javascript': ['tsserver'],
  \'javascript.tsx': ['tsserver'],
  \'typescript': ['tsserver', 'tslint'],
  \'typescript.tsx': ['tsserver', 'tslint'],
\}

let ale_fixers = {
  \'json': ['prettier'],
  \'typescript': ['tslint', 'prettier'],
  \'typescript.tsx': ['tslint', 'prettier'],
\}

call expand_region#custom_text_objects({'a]': 1, 'ab': 1, 'aB': 1})

" ------------------------------------------------------------ # Auto commands #

autocmd FileType html,css,scss,typescript.tsx,javascript,javascript.jsx EmmetInstall

augroup base
  autocmd!
  autocmd FileType qf wincmd J
augroup end

" ----------------------------------------------------------------- # Commands #

command! -bang -nargs=* Grep call s:grep(<q-args>, <bang>0)

" ----------------------------------------------------------------- # Mappings #

nnoremap <silent> <a-n> :Explore<cr>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>
nnoremap <silent> <c-c> :bdelete<cr>

nnoremap <silent> <c-p> :cprev<cr>
nnoremap <silent> <c-n> :cnext<cr>

nnoremap <silent> <a-l> :call <sid>toggle_loc_list()<cr>
nnoremap <silent> <a-c> :call <sid>toggle_quick_fix()<cr>

nnoremap <silent> <a-/> :noh<cr>

nnoremap <a-f> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>
nnoremap <a-b> :Buffers<cr>
nnoremap <a-d> :ALEGoToDefinition<cr>
nnoremap <a-r> :ALEFindReferences<cr>
map      <a-v> <plug>(expand_region_expand)

inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

nnoremap <silent> <expr> <s-h> <sid>preview_opened()
  \? ":pclose\<cr>"
  \: ":ALEHover\<cr>"
