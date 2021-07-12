" Air line settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

" workarround for fixing grey buffers
autocmd VimEnter * hi! link airline_tablabel_right airline_tabtype
autocmd VimEnter * hi! link airline_tablabel airline_tabtype
