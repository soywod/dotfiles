set nocompatible

" ------------------------------------------------------------------ # Plugins #

call plug#begin()

" LSP & completion
Plug 'roxma/nvim-yarp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-vim-lsp'
Plug 'w0rp/ale'

" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Utilities
" Plug 'junegunn/vader.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'soywod/phonetics.vim'
Plug 'soywod/kronos.vim'
Plug 'sirver/ultisnips'
Plug 'zhimsel/vim-stay'
Plug 'soywod/iris.vim'
Plug 'plasticboy/vim-markdown'

" Theme and syntax
Plug 'rakr/vim-one'
Plug 'soywod/typescript.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'iloginow/vim-stylus'
" Plug 'cakebaker/scss-syntax.vim'
Plug 'tpope/vim-haml'
Plug 'digitaltoad/vim-pug'

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
set shortmess+=c
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

let g:ncm2#complete_length = 1

let g:lsp_signs_enabled = 1
let g:lsp_preview_position = 'below'
let g:lsp_preview_auto_resize = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_error = {'text': 'E>'}
let g:lsp_signs_warning = {'text': 'W>'}
let g:lsp_signs_hint = {'text': 'H>'}

let g:ale_sign_error = 'E>'
let g:ale_sign_warning = 'W>'
let g:ale_pattern_options = {
  \'.*node_modules/.*$': {'ale_enabled': 0},
\}

let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \'javascript': ['prettier'],
  \'javascript.jsx': ['prettier'],
  \'typescript': ['prettier'],
  \'typescript.tsx': ['prettier'],
\}

let g:ale_linters = {
  \'sass': ['stylelint'],
\}

let g:kronos_sync = 1

let g:iris_name = 'Clément DOUIN'
let g:iris_email = 'mail@soywod.me'
let g:iris_imap_host = 'mail.soywod.me'
let g:iris_imap_login = 'mail'

let g:UltiSnipsExpandTrigger = '<m-cr>'
let g:UltiSnipsJumpForwardTrigger = '<cr>'

" ------------------------------------------------------------ # Auto commands #

augroup completion
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  autocmd User lsp_setup call lsp#register_server({
    \'name': 'typescript-language-server',
    \'cmd': {server_info->[
      \&shell,
      \&shellcmdflag,
      \'node_modules/.bin/typescript-language-server --stdio',
    \]},
    \'root_uri':{server_info->
      \lsp#utils#path_to_uri(
        \lsp#utils#find_nearest_parent_file_directory(
          \lsp#utils#get_buffer_path(),
          \'tsconfig.json'
        \)
      \)
    \},
    \'whitelist': ['typescript', 'typescript.tsx'],
  \})

  autocmd User lsp_setup call lsp#register_server({
    \'name': 'javascript-language-server',
    \'cmd': {server_info->[
      \&shell,
      \&shellcmdflag,
      \'node_modules/.bin/typescript-language-server --stdio'
      \]},
    \'whitelist': ['javascript', 'javascript.jsx'],
  \})

  " autocmd User Ncm2Plugin call ncm2#register_source({
  "   \'name' : 'stylus',
  "   \'priority': 2, 
  "   \'subscope_enable': 1,
  "   \'mark': 'stylus',
  "   \'word_pattern': '[\w\-]+',
  "   \'complete_pattern': '\.',
  "   \'on_complete': [
  "     \'ncm2#on_complete#omni',
  "     \'stylcomplete#CompleteStyl',
  "   \],
  " \})

  autocmd User Ncm2Plugin call ncm2#register_source({
    \'name' : 'sass',
    \'priority': 2, 
    \'subscope_enable': 1,
    \'mark': 'sass',
    \'word_pattern': '[\w\-]+',
    \'complete_pattern': '\.',
    \'on_complete': [
      \'ncm2#on_complete#omni',
      \'csscomplete#CompleteCSS',
    \],
  \})

  " autocmd User Ncm2Plugin call ncm2#register_source({
  "   \'name' : 'iris-edit',
  "   \'priority': 2, 
  "   \'subscope_enable': 1,
  "   \'mark': 'contacts',
  "   \'word_pattern': '[a-zA-Z1-9\._@]\+',
  "   \'complete_pattern': '[ ,]',
  "   \'on_complete': [
  "     \'ncm2#on_complete#omni',
  "     \'iris#utils#completeContacts',
  "   \],
  " \})
augroup end

augroup base
  autocmd!
  autocmd FileType * setlocal fo-=c fo-=r fo-=o
  autocmd FileType qf wincmd J
augroup end

" ----------------------------------------------------------------- # Commands #

command! -bang -nargs=* Grep call s:grep(<q-args>, <bang>0)
command! DiffOrig call s:diff_origin()

" ----------------------------------------------------------------- # Mappings #

nnoremap <silent> <a-n> :Explore<cr>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>
nnoremap <silent> <c-c> :bdelete<cr>

nnoremap <silent> <c-p> :cprev<cr>
nnoremap <silent> <c-n> :cnext<cr>

nnoremap <silent> <a-l> :call <sid>toggle_loc_list()<cr>
nnoremap <silent> <a-c> :call <sid>toggle_quick_fix()<cr>
nnoremap <silent> <a-t> :Kronos<cr>
nnoremap <silent> <a-p> :PhoneticsPlay<cr>

nnoremap <silent> <a-/> :noh<cr>

nnoremap <a-f> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>
nnoremap <a-b> :Buffers<cr>
nnoremap <a-d> :LspDefinition<cr>
nnoremap <a-r> :LspReferences<cr>
nnoremap <s-a-r> :LspRename<cr>

inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
nnoremap <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>

nnoremap <silent> <expr> <s-h> <sid>preview_opened()
  \? ":pclose\<cr>"
  \: ":LspHover\<cr>"
