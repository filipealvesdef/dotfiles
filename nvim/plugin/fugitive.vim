nmap <leader>gg :let filename=expand('%:t')<CR>
    \ :G<CR><C-w><s-T>
    \ :execute '/'.filename<CR>0
nmap <leader>gh :tabedit %<CR>:Gvdiffsplit!<CR>
noremap <leader>gu :diffget<CR>
noremap <leader>ga :diffput<CR>
