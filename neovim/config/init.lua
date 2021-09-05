-- Packages

local use = require('use-pkg')

use('telescope')
use('ultisnips')
use('cmp')

use('treesitter')
use('lsp')
use('emmet')
use('abolish')
use('commentary')
use('gnupg')
use('repeat')
use('surround')
use('ledger')

use('galaxyline')
use('gitsigns')
use('diffview')
use('neogit')

-- Vim settings

vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.o.background = 'dark'
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menuone,noselect'
vim.o.expandtab = true
vim.o.foldlevelstart = 99
vim.o.hidden = true
vim.o.pumheight = 12
vim.o.ruler = false
vim.o.runtimepath = vim.o.runtimepath..',~/Code/himalaya/vim'
vim.o.runtimepath = vim.o.runtimepath..',~/Code/unfog.vim'
vim.o.shiftwidth = 2
vim.o.shortmess = 'ctT'
vim.o.showbreak = '~'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.statusline = '%m%{luaeval("lsp_status_line()")}%=%r%y'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.writebackup = false
vim.opt.fillchars = vim.opt.fillchars + 'diff:╱'
vim.wo.breakindent = true
vim.wo.breakindentopt = 'sbr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldmethod = 'expr'
vim.wo.number = true
vim.wo.relativenumber = true

-- Theme
-- https://github.com/hlissner/emacs-doom-themes/blob/master/themes/doom-one-theme.el

vim.cmd [[syntax on
highlight Normal													guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Character   	      	      	  guifg=#98be65 guibg=NONE    gui=NONE
highlight String	      	      	  	    guifg=#98be65 guibg=NONE    gui=NONE
highlight Boolean			  	                guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Number      	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Float	      	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Constant    	      	      	  guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight Type		      	      	        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Typedef	      	      	        guifg=#ecbe7b guibg=NONE    gui=NONE
highlight Function    	      	      	  guifg=#c678dd guibg=NONE    gui=NONE
highlight IncSearch              	        guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight Search              	      	  guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight StatusLine          	      	  guifg=#bbc2cf guibg=#21242b gui=NONE
highlight StatusLineNC	      	      	  guifg=#5b6268 guibg=#21242b gui=NONE
highlight Identifier  	      	      	  guifg=#a9a1e1 guibg=NONE    gui=NONE
highlight Pmenu				                    guifg=#bbc2cf guibg=#21242b gui=NONE
highlight PmenuSel              	        guifg=#bbc2cf guibg=#2257a0 gui=NONE
highlight Title		      	      	        guifg=#282c34 guibg=NONE    gui=NONE
highlight NonText	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Comment	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight Folded              	      	  guifg=#5b6268 guibg=NONE    gui=NONE
highlight LineNr	      	      	        guifg=#5b6268 guibg=NONE    gui=NONE
highlight VertSplit	      	      	      guifg=#3f444a guibg=NONE    gui=NONE
highlight CursorLine        	      	    guifg=NONE    guibg=#21242b gui=NONE
highlight CursorLineNr        	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight MatchParen          	      	  guifg=#ff6c6b guibg=#21242b gui=bold
highlight SpecialComment      	      	  guifg=#5b6268 guibg=NONE    gui=italic
highlight Delimiter   	      	      	  guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Visual	      	      	        guifg=NONE	  guibg=#3f444a gui=NONE

highlight Statement	      	      	      guifg=#51afef guibg=NONE    gui=NONE
highlight Conditional 	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Define      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Exception   	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Include     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Keyword     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Label	      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Operator    	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight PreProc     	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Repeat      	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight StorageClass	      	      	  guifg=#51afef guibg=NONE    gui=NONE
highlight Structure	      	      	      guifg=#51afef guibg=NONE    gui=NONE
highlight FoldColumn	      	      	    guifg=NONE guibg=NONE    gui=NONE

highlight Special     	      	      	   guifg=#bbc2cf guibg=NONE    gui=NONE
highlight Tag		      	      	           guifg=#c678dd guibg=NONE    gui=NONE
highlight TabLine             	      	   guifg=#bbc2cf guibg=#282c34 gui=NONE
highlight TabLineFill         	      	   guifg=#bbc2cf guibg=#282c34 gui=NONE
highlight TabLineSel          	      	   guifg=#282c34 guibg=#c678dd gui=NONE
highlight TelescopeBorder        	         guifg=#c678dd guibg=NONE    gui=NONE
highlight TelescopeResultsBorder           guifg=#3f444a guibg=NONE    gui=NONE
highlight TelescopeNormal        	         guifg=#bbc2cf guibg=NONE    gui=NONE
highlight TelescopeSelection	      	     guifg=#bbc2cf guibg=#3f444a gui=NONE
highlight TelescopeMatching              	 guifg=#dfdfdf guibg=#c678dd gui=NONE
highlight TelescopeSelectionCaret	      	 guifg=#c678dd guibg=#3f444a gui=NONE
highlight TelescopePromptPrefix            guifg=#c678dd guibg=NONE    gui=bold
highlight TelescopeMultiSelection	         guifg=#c678dd guibg=NONE    gui=NONE
highlight Error               	      	   guifg=#ff6c6b guibg=NONE    gui=bold
highlight ErrorMsg            	      	   guifg=#ff6c6b guibg=NONE    gui=bold
highlight Success guifg=#98be65 guibg=NONE gui=NONE

highlight DiffAdd guifg=NONE guibg=#323938 gui=NONE
highlight DiffAddAsDelete guifg=NONE guibg=#323938 gui=NONE
highlight DiffChange guifg=NONE guibg=NONE gui=NONE
highlight DiffAddAsDelete guifg=NONE guibg=#3c3239 gui=NONE
highlight! link DiffText Visual
highlight! link DiffDelete Comment

highlight GitSignsAdd guifg=#98be65 guibg=NONE gui=NONE
highlight GitSignsChange guifg=#51afef guibg=NONE gui=NONE
highlight GitSignsDelete guifg=#ff6c6b guibg=NONE gui=NONE

highlight LspDiagnosticsDefaultInformation   guifg=#bbc2cf guibg=NONE    gui=NONE
highlight LspDiagnosticsUnderlineInformation guifg=#3f444a guibg=#bbc2cf gui=NONE
highlight LspDiagnosticsDefaultHint          guifg=#46d9ff guibg=NONE    gui=NONE
highlight LspDiagnosticsUnderlineHint        guifg=#282c34 guibg=#46d9ff gui=NONE
highlight LspDiagnosticsDefaultWarning       guifg=#da8548 guibg=NONE    gui=NONE
highlight LspDiagnosticsUnderlineWarning     guifg=#282c34 guibg=#da8548 gui=NONE
highlight LspDiagnosticsDefaultError         guifg=#ff6c6b guibg=NONE    gui=NONE
highlight LspDiagnosticsUnderlineError       guifg=#282c34 guibg=#ff6c6b gui=NONE

highlight! link SignColumn Comment

highlight DiffviewFilePanelDeletions       guifg=#ff6c6b guibg=NONE gui=NONE
highlight DiffviewFilePanelInsertions       guifg=#98be65 guibg=NONE gui=NONE
  
highlight! link DiffviewFilePanelFileName Normal
highlight! link DiffviewFilePanelTitle Comment
highlight! link DiffviewFilePanelCounter Comment
]]

-- Neogit
vim.cmd [[

highlight NeogitStashes guifg=#98be65 guibg=NONE gui=NONE
highlight NeogitDiffContextHighlight guifg=NONE guibg=#23272e gui=NONE
highlight NeogitHunkHeaderHighlight guifg=#5b6268 guibg=#23272e gui=NONE

highlight NeogitDiffAddHighlight guifg=#98be65 guibg=#23272e gui=NONE
highlight NeogitDiffDeleteHighlight guifg=#ff6c6b guibg=#23272e gui=NONE

highlight! link NeogitHunkHeader Normal
highlight! link NeogitFold Comment
highlight! link NeogitDiffAdd Comment
highlight! link NeogitDiffDelete Comment

highlight! link NeogitHeadRegion Comment

highlight! link NeogitUnmergedInto Error
highlight! link NeogitUnpulledFrom Error
highlight! link NeogitUntrackedfiles Error
highlight! link NeogitUntrackedfilesRegion Error
highlight! link NeogitUnstagedchanges Error
highlight! link NeogitUnstagedchangesRegion Error
highlight! link NeogitUnmergedchanges Error
highlight! link NeogitUnmergedchangesRegion Error
highlight! link NeogitUnpulledchanges Error
highlight! link NeogitUnpulledchangesRegion Error

highlight! link NeogitStash Success
highlight! link NeogitStagedchanges Success
highlight! link NeogitStagedchangesRegion Success
highlight! link NeogitStashesRegion Success



]]

-- Emails

vim.cmd [[
highlight! link mailSubject mailHeaderKey
highlight! link mailEmail mailURL

highlight mailURL guifg=#51afef guibg=NONE gui=NONE
]]

-- TODO: sort
-- highlight SpecialChar 	      	      	  guifg=#da8548 guibg=NONE    gui=NONE
-- highlight LspDiagnosticsFloatingError	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsFloatingHint	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsFloatingWarning	  guifg=NONE	guibg=NONE    gui=NONE
-- highlight LspDiagnosticsUnderlineHint	  guifg=#3b4252 guibg=#b48ead gui=NONE
-- highlight LspDiagnosticsUnderlineInfo	  guifg=#3b4252	guibg=#b48ead gui=NONE
-- highlight LspDiagnosticsUnderlineWarning  guifg=#3b4252 guibg=#ebcb8b gui=NONE
-- highlight LspReferenceRead	          guifg=NONE	guibg=#434c5e gui=NONE
-- highlight LspReferenceText                guifg=NONE    guibg=#434c5e gui=NONE
-- highlight LspReferenceWrite	          guifg=NONE    guibg=#434c5e gui=NONE
-- highlight Todo		      	      	  guifg=#ebcb8b guibg=NONE    gui=NONE
-- highlight Warning			  guifg=#3b4252 guibg=#ebcb8b gui=NONE
-- highlight WarningMsg			  guifg=#ebcb8b guibg=NONE    gui=bold

-- Mappings

local map_opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<a-m>', ":Himalaya<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-t>', ":Unfog<cr>", map_opts)
vim.api.nvim_set_keymap('n', '<a-e>', ":Explore<cr>", map_opts)
