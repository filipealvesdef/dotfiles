let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'
let g:gitgutter_sign_removed_first_line = '┃'
let g:gitgutter_sign_modified_removed = '┃'

hi GitGutterAdd ctermbg=None guifg=#b8bb26
hi GitGutterChange ctermbg=None guifg=#83a598
hi GitGutterDelete ctermbg=None guifg=#fb4934
hi GitGutterChangeDelete ctermbg=None guifg=#83a598

nmap <leader>gj :GitGutterNextHunk<CR>
nmap <leader>gk :GitGutterPrevHunk<CR>

" This is useful for update gutters after add hunks with fugitive
autocmd BufWinLeave * GitGutterAll
