" vim:ft=vim

set nocompatible

" ------------------------------------------------------------------ # Plugins #

call plug#begin()

" Completion engine
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'neoclide/coc-neco', {'for': 'vim'}
Plug 'shougo/neco-vim'  , {'for': 'vim'}

Plug 'junegunn/fzf'     , {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Utilities
Plug 'jamessan/vim-gnupg'
Plug 'mattn/emmet-vim'
Plug 'sirver/ultisnips'
Plug 'soywod/autosess.vim'
Plug 'soywod/kronos.vim'
Plug 'soywod/quicklist.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Theme and syntax
Plug 'arcticicestudio/nord-vim'
Plug 'elzr/vim-json'          , {'for': 'json'}
Plug 'othree/html5.vim'       , {'for': 'html'}
Plug 'hail2u/vim-css3-syntax' , {'for': 'css'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
Plug 'mxw/vim-jsx'            , {'for': ['javascript', 'javascript.jsx']}
Plug 'soywod/typescript.vim'  , {'for': ['typescript', 'typescript.jsx']}
Plug 'vim-ruby/vim-ruby'      , {'for': ['ruby']}

call plug#end()

" ----------------------------------------------------------------- # Settings #

set autoindent
set background=dark
set backspace=indent,eol,start
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
set noswapfile
set nowritebackup
set number
set relativenumber
set ruler
set scrolloff=3
set shiftwidth=2
set shortmess+=ctT
set smartcase
set softtabstop=2
set splitbelow
set statusline=%<%f\ %h%m%r%=%=%y\ %-14.(%l,%c-%{strwidth(getline('.'))}%)\ %P
set tabstop=2
set termguicolors
set ttimeoutlen=50
set undodir=~/.config/nvim/undo//
set undofile
set updatetime=300
set viewoptions=cursor,folds,slash,unix
set wildmenu

" -------------------------------------------------------------------- # Theme #

colorscheme nord

highlight Error               guibg=#BF616A guifg=#D8DEE9 gui=NONE
highlight ErrorMsg            guibg=NONE    guifg=#BF616A gui=Bold
highlight CocErrorHighlight   guibg=#BF616A guifg=#D8DEE9 gui=NONE
highlight CocErrorSign        guibg=#BF616A guifg=#D8DEE9 gui=NONE
highlight Warning             guibg=#EBCB8B guifg=#D8DEE9 gui=NONE
highlight WarningMsg          guibg=NONE    guifg=#EBCB8B gui=Bold
highlight CocWarningHighlight guibg=#EBCB8B guifg=#D8DEE9 gui=NONE
highlight CocWarningSign      guibg=#EBCB8B guifg=#D8DEE9 gui=NONE

" ------------------------------------------------------------- # Plugins conf #

let g:UltiSnipsExpandTrigger = '<m-cr>'
let g:UltiSnipsJumpForwardTrigger = '<cr>'

let g:user_emmet_leader_key = ','
let g:user_emmet_mode = 'a'
let g:user_emmet_install_global = 0

" ---------------------------------------------------------------- # Functions #

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute printf('h %s', expand('<cword>'))
  else
    call CocAction('doHover')
  endif
endfunction

function! s:grep(args, bang)
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

" ----------------------------------------------------------------- # Commands #

command! -bang -nargs=* Grep call s:grep(<q-args>, <bang>0)

augroup dotfiles
  autocmd!
  autocmd CursorHold  *   silent call CocActionAsync('highlight')
  autocmd FileType    *   setlocal fo-=c fo-=r fo-=o
  autocmd FileType    qf  wincmd J
  autocmd FileType    css,scss,javascript*,typescript*  EmmetInstall
augroup end

" ----------------------------------------------------------------- # Mappings #

nnoremap  <silent>  <a-n> :Explore<cr>
nnoremap  <silent>  <c-c> :bwipeout<cr>
nnoremap  <silent>  <a-/> :noh<cr>
nmap      <silent>  <a-d> <plug>(coc-definition)
nmap      <silent>  <a-r> <plug>(coc-references)
nnoremap  <silent>  K     :call <sid>show_documentation()<cr>
vnoremap  <silent>  <a-s> :'<,'>sort<cr>

nmap      <a-R> <plug>(coc-rename)
nmap      <a-a> <Plug>(coc-codeaction)
nnoremap  <a-t> :Kronos<cr>
nnoremap  <a-f> :Files<cr>
nnoremap  <a-g> :Grep 
nnoremap  <a-h> :History<cr>
nnoremap  <a-b> :Buffers<cr>
nnoremap  <a-e> :w<cr>:!%:p<cr>
vnoremap  .     :normal .<cr>

inoremap  <expr> <c-j>    pumvisible() ? "\<c-y>" : "\<c-g>u\<c-j>"
inoremap  <expr> <tab>    pumvisible() ? "\<c-n>" : "\<tab>"
inoremap  <expr> <s-tab>  pumvisible() ? "\<c-p>" : "\<s-tab>"

inoremap  <silent> <expr> <c-space>  coc#refresh()
