" ------------------------------------------------------------------- # Plugin #

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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'kopischke/vim-stay'
Plug 'soywod/phonetics.vim'
Plug 'soywod/kronos.vim'
Plug 'sirver/ultisnips'
Plug 'soywod/autosave.vim'
" Plug 'soywod/iris.vim'

" Theme and syntax
Plug 'soywod/typescript.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'iloginow/vim-stylus'
Plug 'digitaltoad/vim-pug'
Plug 'kchmck/vim-coffee-script'

call plug#end()

" ----------------------------------------------------------------- # Function #

function! s:on_insert_enter()
  highlight StatusLine guibg=#4078f2 guifg=#fafafa gui=None
endfunction

function! s:on_insert_leave()
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

function! s:preview_opened()
  for buffer in range(1, winnr('$'))
    if getwinvar(buffer, "&previewwindow") == 1
      return 1
    endif  
  endfor

  return 0
endfunction

" ------------------------------------------------------------------ # Setting #

set background=light
set backspace=indent,eol,start
set backupcopy=yes
set breakindent
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
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
set omnifunc=syntaxcomplete#Complete
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=c
set smartcase
set softtabstop=2
set splitright
set statusline=\ \:%-3p\ %-3{strwidth(getline('.'))}\ %l
set statusline+=%=%y\ %f
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

let g:ale_fixers = {
  \'javascript': ['prettier'],
  \'javascript.jsx': ['prettier'],
\}

let g:kronos_sync = 1

let g:iris_host = 'imap.gmail.com'
let g:iris_email = 'clement.douin@gmail.com'

let g:UltiSnipsExpandTrigger = '<cr>'
let g:UltiSnipsJumpForwardTrigger  = '<cr>'

" ------------------------------------------------------------------ # Command #

autocmd User lsp_setup call lsp#register_server({
  \'name': 'typescript-language-server',
  \'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
  \'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
  \'whitelist': ['javascript.jsx', 'typescript', 'typescript.tsx'],
\})

autocmd User lsp_setup call lsp#register_server({
  \'name': 'javascript-language-server',
  \'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
  \'whitelist': ['javascript', 'javascript.jsx'],
\})

autocmd User Ncm2Plugin call ncm2#register_source({
  \'name' : 'coffee',
  \'priority': 2, 
  \'subscope_enable': 1,
  \'mark': 'coffee',
  \'word_pattern': '\w+',
  \'complete_pattern': ['\.'],
  \'on_complete': ['ncm2#on_complete#omni', 'javascriptcomplete#CompleteJS'],
\})

autocmd User Ncm2Plugin call ncm2#register_source({
  \'name' : 'stylus',
  \'priority': 2, 
  \'subscope_enable': 1,
  \'mark': 'stylus',
  \'word_pattern': '[\w\-]+',
  \'complete_pattern': '\.',
  \'on_complete': ['ncm2#on_complete#omni', 'stylcomplete#CompleteStyl'],
\})

autocmd BufEnter * call ncm2#enable_for_buffer()

autocmd FileType qf wincmd J
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd InsertEnter * call s:on_insert_enter()
autocmd InsertLeave * call s:on_insert_leave()

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

nnoremap <silent> <a-/> :noh<cr>

nnoremap <a-f> :Files<cr>
nnoremap <a-g> :Grep 
nnoremap <a-h> :History<cr>
nnoremap <a-d> :LspDefinition<cr>
nnoremap <a-r> :LspReferences<cr>
nnoremap <s-a-r> :LspRename<cr>

inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
nnoremap <silent> <expr> <s-h> <sid>preview_opened() ? ":pclose\<cr>" : ":LspHover\<cr>"

nnoremap <a-s> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
