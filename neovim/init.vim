function! s:load_plugins(...) abort
  " {{{ Minpac
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac')

  command! PackUpdate call minpac#update()
  command! PackClean  call minpac#clean()
  command! PackStatus call minpac#status()
  " }}}

  call minpac#add('jamessan/vim-gnupg')

  " {{{ Tpope suite
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-repeat')
  " }}}

  " {{{ Tree-sitter
  call minpac#add('nvim-treesitter/nvim-treesitter')

  lua <<EOF
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash',
      'css',
      'graphql',
      'haskell',
      'html',
      'javascript',
      'json',
      'ledger',
      'lua',
      'nix',
      'php',
      'rust',
      'toml',
      'tsx',
      'typescript',
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<a-v>',
        node_incremental = '<a-v>',
        node_decremental = '<a-V>',
      },
    },
  })
EOF
  " }}}

  " {{{ CoC
  call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
  endfunction

  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h ' . expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . ' ' . expand('<cword>')
    endif
  endfunction

  function! s:definition()
    echom 'coucou'
    if (index(['vim', 'help'], &filetype) >= 0)
      execute printf('tag %s', expand('<cword>'))
    elseif coc#rpc#ready() == 1
      call CocActionAsync('jumpDefinition')
    endif
  endfunction

  inoremap <silent> <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
  inoremap <silent> <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  inoremap <silent> <expr> <C-Space> coc#refresh()

  nmap <silent> <a-p> <Plug>(coc-diagnostic-prev)
  nmap <silent> <a-n> <Plug>(coc-diagnostic-next)
  nmap <silent> <a-r> <Plug>(coc-references)
  nmap <silent> <a-R> <Plug>(coc-rename)
  nmap <silent> <a-c> <Plug>(coc-codeaction)

  nnoremap <silent> K     :call <SID>show_documentation()<CR>
  nnoremap <silent> <C-]> :call <SID>definition()<CR>

  highlight CocErrorSign                   guifg=#ff6c6b guibg=NONE    gui=NONE
  highlight CocHintSign                    guifg=#46d9ff guibg=NONE    gui=NONE
  highlight CocInfoSign                    guifg=#bbc2cf guibg=NONE    gui=NONE
  highlight CocWarningSign                 guifg=#da8548 guibg=NONE    gui=NONE
  highlight DiagnosticDefaultError         guifg=#ff6c6b guibg=NONE    gui=NONE
  highlight DiagnosticDefaultHint          guifg=#46d9ff guibg=NONE    gui=NONE
  highlight DiagnosticDefaultInformation   guifg=#bbc2cf guibg=NONE    gui=NONE
  highlight DiagnosticDefaultWarning       guifg=#da8548 guibg=NONE    gui=NONE
  highlight DiagnosticError                guifg=#ff6c6b guibg=NONE    gui=NONE
  highlight DiagnosticHint                 guifg=#46d9ff guibg=NONE    gui=NONE
  highlight DiagnosticInformation          guifg=#bbc2cf guibg=NONE    gui=NONE
  highlight DiagnosticUnderlineError       guifg=#282c34 guibg=#ff6c6b gui=NONE
  highlight DiagnosticUnderlineHint        guifg=#282c34 guibg=#46d9ff gui=NONE
  highlight DiagnosticUnderlineInformation guifg=#3f444a guibg=#bbc2cf gui=NONE
  highlight DiagnosticUnderlineWarning     guifg=#282c34 guibg=#da8548 gui=NONE
  highlight DiagnosticWarning              guifg=#da8548 guibg=NONE    gui=NONE
  highlight CocRustTypeHint                guifg=#5b6268 guibg=NONE    gui=NONE
  highlight CocRustChainingHint            guifg=#5b6268 guibg=NONE    gui=italic
  " }}}

  " {{{ FZF
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('antoinemadec/coc-fzf')

  let g:fzf_preview_window = {}
  let g:fzf_layout = {'down': '~40%'}

  nnoremap <silent> <a-w> :CocFzfList outline<CR>
  nnoremap <silent> <a-W> :CocFzfList symbols<CR>
  nnoremap <silent> <a-g> :Rg <CR>
  nnoremap <silent> <a-f> :Files<CR>
  nnoremap <silent> <a-h> :History<CR>
  nnoremap <silent> <a-b> :Buffers<CR>
  nnoremap <silent> <a-l> :Lines<CR>

  highlight fzf1 guifg=#c678dd guibg=#21242b gui=NONE
  highlight fzf2 guifg=#bbc2cf guibg=#21242b gui=NONE
  highlight fzf3 guifg=#bbc2cf guibg=#21242b gui=NONE
  " }}}
endfunction

let minpac_path = expand('~/.config/nvim/pack/minpac/start/minpac')
if empty(expand(glob(minpac_path)))
  let cmd = printf('git clone https://github.com/k-takata/minpac.git %s', minpac_path)
  call jobstart(cmd, {'on_stdout': function('s:load_plugins')})
else
  call s:load_plugins()
endif

augroup tabasco
  autocmd BufNewFile,BufRead *.tbc setfiletype tabasco
augroup end

" {{{ Options
syntax on
set background=dark
set breakindent
set breakindentopt=sbr
set clipboard=unnamedplus
set completeopt=menuone,noselect
set expandtab
set fillchars+=diff:⁄
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99
set foldlevelstart=99
set foldmethod=expr
set hidden
set nobackup
set noruler
set nowritebackup
set number
set pumheight=12
set relativenumber
set runtimepath+=,~/Code/himalaya/vim
set runtimepath+=,~/Code/unfog.vim
set runtimepath+=,~/Code/tabasco/vim
set shiftwidth=2
set shortmess=ctT
set showbreak=~
set signcolumn=yes
set smartcase
set splitbelow
set splitright
set statusline=%m%r\ %{coc#status()}\ %{get(b:,'coc_current_function','')}%=%y\ %-10.(%l,%v%)\ %P%{FugitiveStatusline()}
set tabstop=2
set termguicolors
set undofile
set updatetime=150
" }}}

" {{{ Mappings
nnoremap <silent> <a-e> :Explore<CR>
nnoremap <silent> <a-m> :Himalaya<CR>
nnoremap <silent> <a-t> :Unfgo<CR>
" }}}

" {{{ Theme
highlight Boolean                        guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Character                      guifg=#98be65 guibg=NONE    gui=NONE
highlight Comment                        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Conditional                    guifg=#51afef guibg=NONE    gui=NONE
highlight Constant                       guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight CursorLine                     guifg=NONE    guibg=#21242b gui=NONE
highlight CursorLineNr                   guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Define                         guifg=#51afef guibg=NONE    gui=NONE
highlight Delimiter                      guifg=#bbc2cf guibg=NONE    gui=NONE
highlight DiffAdd                        guifg=NONE    guibg=#343c39 gui=NONE
highlight DiffChange                     guifg=NONE    guibg=#343c39 gui=NONE
highlight DiffDelete                     guifg=NONE    guibg=#40333a gui=NONE
highlight DiffText                       guifg=NONE    guibg=#414c3f gui=NONE
highlight Directory                      guifg=#51afef guibg=NONE    gui=bold
highlight Error                          guifg=#ff6c6b guibg=NONE    gui=bold
highlight ErrorMsg                       guifg=#ff6c6b guibg=NONE    gui=bold
highlight Exception                      guifg=#51afef guibg=NONE    gui=NONE
highlight Float                          guifg=#bbc2cf guibg=NONE    gui=NONE
highlight FoldColumn                     guifg=NONE    guibg=NONE    gui=NONE
highlight Folded                         guifg=#5b6268 guibg=NONE    gui=NONE
highlight Function                       guifg=#c678dd guibg=NONE    gui=NONE
highlight Identifier                     guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight IncSearch                      guifg=#282c34 guibg=#ecbe7b gui=NONE
highlight Include                        guifg=#51afef guibg=NONE    gui=NONE
highlight Keyword                        guifg=#51afef guibg=NONE    gui=NONE
highlight Label                          guifg=#51afef guibg=NONE    gui=NONE
highlight LineNr                         guifg=#5b6268 guibg=NONE    gui=NONE
highlight MatchParen                     guifg=#ff6c6b guibg=#21242b gui=bold
highlight NonText                        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Normal                         guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Number                         guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Operator                       guifg=#51afef guibg=NONE    gui=NONE
highlight Pmenu                          guifg=#bbc2cf guibg=#21242b gui=NONE
highlight PmenuSel                       guifg=#bbc2cf guibg=#2257a0 gui=NONE
highlight PreProc                        guifg=#51afef guibg=NONE    gui=NONE
highlight Repeat                         guifg=#51afef guibg=NONE    gui=NONE
highlight Search                         guifg=#282c34 guibg=#ecbe7b gui=NONE
highlight SignColumn                     guifg=#5b6268 guibg=NONE    gui=NONE
highlight Special                        guifg=#bbc2cf guibg=NONE    gui=NONE
highlight SpecialComment                 guifg=#5b6268 guibg=NONE    gui=italic
highlight Statement                      guifg=#51afef guibg=NONE    gui=NONE
highlight StatusLine                     guifg=#bbc2cf guibg=#21242b gui=NONE
highlight StatusLineNC                   guifg=#5b6268 guibg=#21242b gui=NONE
highlight StorageClass                   guifg=#51afef guibg=NONE    gui=NONE
highlight String                         guifg=#98be65 guibg=NONE    gui=NONE
highlight Structure                      guifg=#51afef guibg=NONE    gui=NONE
highlight Success                        guifg=#98be65 guibg=NONE    gui=NONE
highlight TabLine                        guifg=#bbc2cf guibg=#282c34 gui=NONE
highlight TabLineFill                    guifg=#bbc2cf guibg=#23272e gui=NONE
highlight TabLineSel                     guifg=#282c34 guibg=#c678dd gui=NONE
highlight Tag                            guifg=#c678dd guibg=NONE    gui=NONE
highlight Title                          guifg=#c678dd guibg=NONE    gui=NONE
highlight Type                           guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Typedef                        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight VertSplit                      guifg=#3f444a guibg=NONE    gui=NONE
highlight Visual                         guifg=NONE    guibg=#3f444a gui=NONE
highlight mailURL                        guifg=#51afef guibg=NONE    gui=NONE

highlight TabascoCategory guifg=#c678dd guibg=NONE gui=NONE
highlight TabascoContext  guifg=#ff6c6b guibg=NONE gui=italic,bold
highlight TabascoProject  guifg=#51afef guibg=NONE gui=italic
highlight TabascoDuration guifg=#ecbe7b guibg=NONE gui=italic
highlight TabascoDate     guifg=#ecbe7b guibg=NONE gui=italic
highlight TabascoPending  guifg=#4db5bd guibg=NONE gui=italic

" }}}

" vim:foldmethod=marker:foldlevel=0
