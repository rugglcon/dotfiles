" clear highlights
highlight clear
if exists('syntax_on')
	syntax reset
endif

" source wal colors
source ~/.cache/wal/colors.vim

set background=dark
let g:colors_name='basic'

execute 'hi String ctermbg=NONE ctermfg=2 cterm=BOLD gui=BOLD guibg=NONE guifg='.g:color2
execute 'hi Number ctermbg=NONE ctermfg=1 guibg=NONE guifg='.g:color1
execute 'hi Comment ctermbg=NONE ctermfg=8 cterm=italic gui=italic guifg='.g:color8
execute 'hi Normal guibg='.g:background.' guifg=White'
execute 'hi Cursor guibg='.g:color1
execute 'hi LineNr ctermbg=NONE ctermfg=8 guibg=NONE guifg='.g:color8
execute 'hi SignColumn ctermbg=NONE guibg='.g:background

" {{{ make everything else plain

hi Constant   cterm=NONE ctermfg=White gui=NONE guifg=White
hi Identifier cterm=NONE ctermfg=White gui=NONE guifg=White
hi Function   cterm=NONE ctermfg=White gui=NONE guifg=White
hi Statement  cterm=NONE ctermfg=White gui=NONE guifg=White
hi PreProc    cterm=NONE ctermfg=White gui=NONE guifg=White
hi Type	      cterm=NONE ctermfg=White gui=NONE guifg=White
hi Special    cterm=NONE ctermfg=White gui=NONE guifg=White
hi Delimiter  cterm=NONE ctermfg=White gui=NONE guifg=White

" }}} end making everything plain

" {{{ set statusline highlights

execute 'hi User1 ctermbg=1 ctermfg=0 guibg='.g:color1.' guifg='.g:color0
execute 'hi User2 ctermbg=0 ctermfg=6 guibg='.g:color0.' guifg='.g:color6
execute 'hi User3 ctermbg=0 ctermfg=2 guibg='.g:color0.' guifg='.g:color2
execute 'hi User4 ctermbg=3* ctermfg=0 guibg='.g:color11.' guifg='.g:color0

" }}} end statusline highlights
