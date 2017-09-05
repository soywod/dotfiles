syntax on
filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')

Plug 'ajh17/VimCompletesMe'
Plug 'editorconfig/editorconfig-vim'
Plug 'flowtype/vim-flow', { 'for': ['javascript', 'javascript.jsx'] }
" Plug 'honza/vim-snippets'
Plug 'jaawerth/nrun.vim'
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'rakr/vim-one'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': ['javascript', 'javascript.jsx'] }
" Plug 'SirVer/ultisnips'
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
hi ALEErrorSign guifg=white guibg=#ca1243
hi ALEWarningSign guifg=white guibg=#c18401

" Flow ----------------------------------------------------------------------------------

let g:flow#enable = 0
let g:flow#flowpath = nrun#Which('flow')
let flow_is_active = (g:flow#flowpath != 'flow not found')

" ESLint ---------------------------------------------------------------------------------

let g:eslint_path = nrun#Which('eslint')
let eslint_is_active = (g:eslint_path != 'eslint not found')

" Prettier -------------------------------------------------------------------------------

let g:prettier_path = nrun#Which('prettier')
let prettier_is_active = (g:prettier_path != 'prettier not found')

" JavaScript -----------------------------------------------------------------------------

let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0

" Deoplete -------------------------------------------------------------------------------

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns['javascript'] = '\.'
let g:deoplete#omni#input_patterns['javascript.jsx'] = '\.'

call denite#custom#var('file_rec', 'command', ['ag', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

" ALE ------------------------------------------------------------------------------------

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
" let g:ale_lint_on_text_changed = 'never'
let g:ale_linter_aliases = {'javascript.jsx': 'javascript'}
let g:ale_fixers_aliases = {'javascript.jsx': 'javascript'}
let g:ale_linters = {'javascript': []}
let g:ale_fixers = {'javascript': []}

if (flow_is_active)
  let g:ale_javascript_flow_executable = g:flow#flowpath
  let g:ale_linters.javascript = g:ale_linters.javascript + ['flow']
endif

if (eslint_is_active)
  let g:ale_javascript_eslint_executable = g:eslint_path
  let g:ale_linters.javascript = g:ale_linters.javascript + ['eslint']
endif

if (prettier_is_active)
  let g:ale_javascript_prettier_executable = g:prettier_path
  let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --parser babylon'
  let g:ale_fixers.javascript = g:ale_fixers.javascript + ['prettier']
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
    :cp
  elseif (getloclist('.') != [])
    :lp
  endif
endfunction

function NextListItem()
  if (getqflist() != [])
    :cn
  elseif (getloclist('.') != [])
    :ln
  endif
endfunction

" Mapping --------------------------------------------------------------------------------

let mapleader = ' '

nnoremap <leader>s :w<CR>
nnoremap <silent> <leader>n :Explore<CR>

nnoremap <silent> <leader>f :Denite file_rec<CR>
nnoremap <silent> <leader>g :Denite grep<CR>
nnoremap <silent> <leader>b :Denite buffer<CR>
nnoremap <silent> <leader>h :Denite file_old<CR>

nnoremap <silent> <leader>c :call ToggleQfList()<CR>
nnoremap <silent> <leader>l :call ToggleLocList()<CR>

nnoremap <silent> [[ :call PrevListItem()<CR>
nnoremap <silent> ]] :call NextListItem()<CR>

" UltiSnips ------------------------------------------------------------------------------
" let g:UltiSnipsExpandTrigger = '<C-b>'
" let g:UltiSnipsJumpForwardTrigger = '<C-b>'
" let g:UltiSnipsSnippetDirectories = ['snips']



