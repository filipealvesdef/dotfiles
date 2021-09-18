call plug#begin(stdpath('data') . '/plugged')
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim'
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'filipealvesdef/vim-fugitive', { 'branch': 'custom-maps' }
Plug 'airblade/vim-gitgutter'
Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
call plug#end()

syntax on
set termguicolors
filetype plugin indent on
set nu rnu
set expandtab
set tabstop=4
set shiftwidth=4
set mouse=a
set colorcolumn=80
set cursorline
set smartindent
set scrolloff=20
set noswapfile
set incsearch
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set signcolumn=yes
set updatetime=100
set guicursor=i:block
set clipboard=unnamedplus
set completeopt=menuone,longest
set noautoread

" Theme
colorscheme gruvbox
hi visual  guifg=#877e67 guibg=#ebdbb2 gui=none
hi Normal guibg=NONE ctermbg=NONE
hi CursorLineNr term=bold gui=bold guifg=#fabd2f guibg=None
hi SignColumn guibg=None

" Mappings
let mapleader = ' '
" Buffer navigation
map <silent><C-H> :bp<CR>
map <silent><C-L> :bn<CR>
map <silent><C-X> :bd<CR>
" allows to navigate in the popup menu with j and k keys
inoremap <silent><expr> <C-j> pumvisible() ? "\<Down>" : "<C-j>"
inoremap <silent><expr> <C-k> pumvisible() ? "\<Up>" : "<C-k>"
" save all buffers and close current tab
map <silent><Leader>tq :wa<CR>:tabclose<CR>
noremap <C-Z> :suspend<CR>:silent! checktime<CR>

" Trailing spaces highlight
highlight ExtraWhitespace ctermbg=160 guibg=#fb4934
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
