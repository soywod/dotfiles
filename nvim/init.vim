syntax on
filetype plugin indent on

call plug#begin()

" LSP Client
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" Completion
Plug 'roxma/nvim-completion-manager'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Theme
Plug 'rakr/vim-one'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'

" Utilities
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ervandew/supertab'

call plug#end()

set background=light
set backspace=indent,eol,start
set breakindent
set clipboard+=unnamedplus,unnamed
set completeopt+=menu
set expandtab
set foldcolumn=2
set history=1000
set hlsearch
set ignorecase
set incsearch
set linebreak
set nobackup
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
set t_Co=256

" Theme ---------------------------------------------------------------------------------

colorscheme one

hi clear FoldColumn
hi clear SignColumn
hi Normal guibg=white
hi CursorLine guibg=#a626a4 guifg=white
hi ALEErrorSign guibg=white guifg=#ca1243
hi ALEWarningSign guibg=white guifg=#c18401
hi ALEStyleErrorSign guibg=#ca1243 guifg=white
hi ALEStyleWarningSign guibg=#c18401 guifg=white

" Auto commands --------------------------------------------------------------------------

au FileType qf wincmd J
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" LanguageClient ------------------------------------------------------------------------

let g:LanguageClient_autoStart = 1
let g:LanguageClient_selectionUI = 'fzf'
let g:LanguageClient_serverCommands = {
  \ 'javascript': ['flow-language-server', '--stdio'],
  \ 'javascript.jsx': ['flow-language-server', '--stdio'],
  \ 'typescript': ['javascript-typescript-stdio'],
  \ }

" JavaScript -----------------------------------------------------------------------------

let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1

" SuperTab -------------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = '<C-n>'

" UltiSnips ------------------------------------------------------------------------------

let g:UltiSnipsExpandTrigger = '<C-b>'
let g:UltiSnipsJumpForwardTrigger = '<C-b>'
let g:UltiSnipsSnippetDirectories = ['snips']

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

function Save()
  :w
endfunction

" Mapping --------------------------------------------------------------------------------

let mapleader = ' '

nnoremap <leader>s :call Save()<CR>
nnoremap <silent> <leader>n :Explore<CR>

nnoremap <leader>g :Ag 
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>

nnoremap <leader>v :call LanguageClient_textDocument_hover()<CR>
nnoremap <leader>d :call LanguageClient_textDocument_definition()<CR>
nnoremap <leader>r :call LanguageClient_textDocument_rename()<CR>

nnoremap <silent> <leader>c :call ToggleQfList()<CR>
nnoremap <silent> <leader>l :call ToggleLocList()<CR>

nnoremap <silent> [[ :call PrevListItem()<CR>
nnoremap <silent> ]] :call NextListItem()<CR>

