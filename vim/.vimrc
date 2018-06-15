call plug#begin()

" LSC
Plug 'natebosch/vim-lsc'

" Fuzzy finder
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'

" Utilities
" Plug 'ap/vim-buftabline'
Plug 'mattn/emmet-vim'
Plug 'soywod/kronos.vim'
Plug 'shougo/neocomplete.vim'
Plug 'ervandew/supertab'
Plug 'junegunn/vader.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'soywod/vim-keepeye'
" Plug 'soywod/vim-phonetics'
Plug 'tpope/vim-surround'
" Plug 'blindfs/vim-taskwarrior'
Plug 'kopischke/vim-stay'

" Theme and syntax
Plug 'rakr/vim-one'
" Plug 'herringtondarkholme/yats.vim'
" Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'

call plug#end()

" Functions ------------------------------------------------------------------------------

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

function! Ranger()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction

" Global settings ------------------------------------------------------------------------

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

colorscheme one

highlight clear FoldColumn
highlight clear SignColumn
highlight StatusLineNC guifg=#f0f0f0 guibg=#f0f0f0
highlight StatusLine guifg=#494B53 guibg=#f0f0f0
highlight FoldColumn guifg=#d3d3d3
highlight Folded guibg=#fafafa guifg=#d3d3d3
highlight User1 guibg=#e45649 guifg=#fafafa

" LSC ------------------------------------------------------------------------------------

let g:lsc_auto_map = v:true
let g:lsc_preview_split_direction = 'below'
let g:lsc_server_commands = {
  \ 'javascript': 'node_modules/.bin/javascript-typescript-stdio',
  \ 'javascript.jsx': 'node_modules/.bin/javascript-typescript-stdio',
  \ 'typescript': 'node_modules/.bin/javascript-typescript-stdio',
  \ 'typescript.tsx': 'node_modules/.bin/javascript-typescript-stdio',
  \ 'typescriptreact': 'node_modules/.bin/javascript-typescript-stdio'
\ }

" Completion -----------------------------------------------------------------------------

let g:neocomplete#enable_at_startup = 1

" JavaScript -----------------------------------------------------------------------------

let g:jsx_ext_required = 1

" SuperTab -------------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = '<C-n>'

" Emmet ----------------------------------------------------------------------------------

let g:user_emmet_install_global = 1
let g:user_emmet_leader_key = ','

" KeepEye --------------------------------------------------------------------------------

let g:keepeye_features = ['bell', 'statusline']
let g:keepeye_timer = 1800

" Auto commands --------------------------------------------------------------------------

autocmd FileType qf wincmd J
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd InsertEnter * call InsertEnter()
autocmd InsertLeave,TextChanged * call Save()
" autocmd BufNewFile,BufRead *.tsx set filetype=javascript.jsx

command! -bar Ranger call Ranger()
command! -nargs=* Search call s:Search(<q-args>)
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" --glob "!.git/*" '.shellescape(<q-args>), 1, <bang>0)

" Mapping --------------------------------------------------------------------------------

let mapleader = ' '

nnoremap <silent> <leader>n :Explore<CR>
nnoremap <silent> <leader>r :<c-u>Ranger<cr>

nnoremap <silent> <c-l> :bnext<cr>
nnoremap <silent> <c-h> :bprev<cr>

nnoremap <leader>f :Files<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>h :History<cr>

nnoremap <silent> <leader>c :call ToggleQfList()<cr>
nnoremap <silent> <leader>l :call ToggleLocList()<cr>
" nnoremap <silent> <leader>p :PhoneticsPlay<cr>

