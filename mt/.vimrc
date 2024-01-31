call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
call plug#end()

syntax enable

set completeopt=menuone,longest
set laststatus=2
set wildmenu
set wrap
set rnu
set nu
set shiftwidth=4
set backspace=indent,eol,start
set cursorline
set clipboard=unnamed
set showcmd
set ignorecase
set smartcase

nnoremap <leader>w	:w<cr>
nnoremap <leader>q  :wq<CR>
nnoremap <leader>ce :e $MYVIMRC<CR>
nnoremap <leader>cr :source $MYVIMRC<CR>
nnoremap <leader>pi :PlugInstall<CR>
