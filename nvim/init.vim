execute pathogen#infect()

syntax on
filetype plugin on
colorscheme one

set background=light
set backspace=indent,eol,start
set breakindent
set clipboard=unnamed
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
let g:flow#flowpath = 'node_modules/.bin/flow'

au FileType qf wincmd J
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

function ToggleQuickFix()
  if (filter(getwininfo(), 'v:val.quickfix') == [])
    :copen
  else
    :cclose
  endif
endfunction

function ToggleLocList()
  if (filter(getwininfo(), 'v:val.loclist') == [])
    :lopen
  else
    :lclose
  endif
endfunction

nnoremap <leader>n :Ex<CR>
nnoremap <leader>f :Denite file_rec<CR>
nnoremap <leader>g :Denite grep<CR>
nnoremap <leader>b :Denite buffer<CR>
nnoremap <leader>h :Denite file_old<CR>
nnoremap <leader>s :w<CR>

call denite#custom#var('file_rec', 'command', ['ag', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

