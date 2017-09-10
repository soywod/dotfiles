syntax on
filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')

Plug 'ajh17/VimCompletesMe'
Plug 'editorconfig/editorconfig-vim'
Plug 'ElmCast/elm-vim', { 'for': ['elm'] }
Plug 'flowtype/vim-flow', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'honza/vim-snippets'
Plug 'jaawerth/nrun.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'rakr/vim-one'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': ['javascript', 'javascript.jsx'] }
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'

call plug#end()

set background=light
set backspace=indent,eol,start
set breakindent
set clipboard+=unnamedplus
set expandtab
set foldcolumn=2
set history=1000
set hlsearch
set ignorecase
set incsearch
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
set tabstop=2
set termguicolors
set ttimeoutlen=50

" Theme ---------------------------------------------------------------------------------

colorscheme one

hi clear FoldColumn
hi clear SignColumn
hi Normal guibg=white
hi CursorLine guibg=#a626a4 guifg=white
hi ALEErrorSign guibg=#ca1243 guifg=white
hi ALEWarningSign guibg=#c18401 guifg=white
hi ALEStyleErrorSign guibg=white guifg=#ca1243
hi ALEStyleWarningSign guibg=white guifg=#c18401

" Flow ----------------------------------------------------------------------------------

let g:flow#enable = 0
let g:flow#flowpath = nrun#Which('flow')
let flow_is_active = (g:flow#flowpath != 'flow not found')

" ESLint ---------------------------------------------------------------------------------

let eslint_is_active = (nrun#Which('eslint') != 'eslint not found')

" Prettier -------------------------------------------------------------------------------

let prettier_is_active = (nrun#Which('prettier') != 'prettier not found')

" Elm ------------------------------------------------------------------------------

let elm_make_is_active = (nrun#Which('elm-make') != 'elm-make not found')
let elm_format_is_active = (nrun#Which('elm-format') != 'elm-format not found')
let g:elm_setup_keybindings = 0

" JavaScript -----------------------------------------------------------------------------

let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" Deoplete -------------------------------------------------------------------------------

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns['javascript'] = '[^. *\t]\.\w*'
let g:deoplete#omni_patterns['javascript.jsx'] = '[^. *\t]\.\w*'
let g:deoplete#omni_patterns['elm'] = '[^ \t]+'

" ALE ------------------------------------------------------------------------------------

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
let g:ale_sign_style_error  = '--'
let g:ale_sign_style_warning  = '--'
let g:ale_statusline_format = ['✗ %d', '⚠ %d', '✔ OK']
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'

let g:ale_linter_aliases = {'javascript.jsx': 'javascript'}
let g:ale_fixers_aliases = {'javascript.jsx': 'javascript'}
let g:ale_linters = {'javascript': [], 'elm': []}
let g:ale_fixers = {'javascript': [], 'elm': []}

if flow_is_active
  let g:ale_linters.javascript = g:ale_linters.javascript + ['flow']
endif

if eslint_is_active
  let g:ale_linters.javascript = g:ale_linters.javascript + ['eslint']
endif

if prettier_is_active
  let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --parser babylon'
  let g:ale_fixers.javascript = g:ale_fixers.javascript + ['prettier']
endif

if elm_make_is_active
  let g:ale_linters.elm = g:ale_linters.elm + ['make']
endif

if elm_format_is_active
  let g:ale_fixers.elm = g:ale_fixers.elm + ['format']
endif

" Auto commands --------------------------------------------------------------------------

au FileType qf wincmd J
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Functions ------------------------------------------------------------------------------

function ToggleQfList()
  if (filter(getwininfo(), 'v:val.quickfix') == [])
    :copen
  else
    :cclose
  endif
endfunction

function ToggleLocList()
  if (getloclist('.') != [])
    if (filter(getwininfo(), 'v:val.loclist') == [])
      :lopen
    else
      :lclose
    endif
  endif
endfunction

function PrevListItem()
  if (getqflist() != [])
    :cprevious
  elseif (getloclist('.') != [])
    :lprevious
  endif
endfunction

function NextListItem()
  if (getqflist() != [])
    :cnext
  elseif (getloclist('.') != [])
    :lnext
  endif
endfunction

" Mapping --------------------------------------------------------------------------------

let mapleader = ' '

nnoremap <leader>s :w<CR>
nnoremap <silent> <leader>n :Explore<CR>

nnoremap <leader>g :Ag 
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>

nnoremap <silent> <leader>c :call ToggleQfList()<CR>
nnoremap <silent> <leader>l :call ToggleLocList()<CR>

nnoremap <silent> [[ :call PrevListItem()<CR>
nnoremap <silent> ]] :call NextListItem()<CR>

" UltiSnips ------------------------------------------------------------------------------

let g:UltiSnipsExpandTrigger = '<C-b>'
let g:UltiSnipsJumpForwardTrigger = '<C-b>'
let g:UltiSnipsSnippetDirectories = ['snips']

