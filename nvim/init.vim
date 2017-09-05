syntax on
filetype plugin indent on

call plug#begin('~/.config/nvim/plugged')

" Utils
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': ['javascript', 'javascript.jsx'] }
Plug 'editorconfig/editorconfig-vim'
Plug 'jaawerth/nrun.vim'
Plug 'ajh17/VimCompletesMe'

" Javascript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'moll/vim-node', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'flowtype/vim-flow', { 'for': ['javascript', 'javascript.jsx'] }

" Git
Plug 'tpope/vim-fugitive'

" Theme
Plug 'rakr/vim-one'

call plug#end()

colorscheme one

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

hi clear FoldColumn
hi Normal guibg=white
hi CursorLine guibg=#a626a4 guifg=white
hi Search guibg=#a626a4
hi IncSearch guifg=#a626a4

let mapleader = ' '

let g:flow#flowpath = nrun#Which('flow')
let g:flow#enable = 0

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns['javascript'] = '\.'
let g:deoplete#omni#input_patterns['javascript.jsx'] = '\.'

au FileType qf wincmd J
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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

nnoremap <leader>n :Ex<CR>
nnoremap <leader>f :Denite file_rec<CR>
nnoremap <leader>g :Denite grep<CR>
nnoremap <leader>b :Denite buffer<CR>
nnoremap <leader>h :Denite file_old<CR>
nnoremap <leader>s :w<CR>
nnoremap <silent> <leader>c :call ToggleQfList()<CR>
nnoremap <silent> <leader>l :call ToggleLocList()<CR>
nnoremap <silent> [[ :call PrevListItem()<CR>
nnoremap <silent> ]] :call NextListItem()<CR>

call denite#custom#var('file_rec', 'command', ['ag', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

