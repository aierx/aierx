call plug#begin('~/.vim/plugged')
" 状态栏
Plug 'itchyny/lightline.vim'
" 代码提示
" Plug 'valloric/youcompleteme'
" 目录栏
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
" 文件搜索
" Plug 'junegunn/fzf',{ 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
" 多光标
" Plug 'terryma/vim-multiple-cursors'
" git
" Plug 'airblade/vim-gitgutter'
" git cimdiff
" Plug 'chrisbra/vim-diff-enhanced'
" Plug 'majutsushi/tagbar'
" Plug 'ervandew/supertab'
" Plug 'tpope/vim-surround'
" Plug 'altercation/vim-colors-solarized'
" Plug 'tpope/vim-fugitive'
" Plug 'scrooloose/syntastic'
call plug#end()

nnoremap <C-t> :NERDTreeToggle<CR>
" 设置 Tab 键为补全键
noremap <Tab>  <C-n>


" vimdiff 快捷键
map dl :diffget L<CR>
map db :diffget B<CR>
map dr :diffget R<CR>

map <leader>w		:w<cr>
map <leader>q  		:wq<CR>
map <leader>Q 		:q!<CR>
map <leader>t		:terminal<CR>
map <leader>d 		:set splitright<CR>:vsplit<CR>
map <leader>s 		:set nosplitbelow<CR>:split<CR>
map <leader>F  		:Files<CR>
map <leader>p       <Plug>(GitGutterPreviewHunk)
map <leader><Up>    :resize -10<CR>
map <leader><Down>  :resize +10<CR>
map <leader><Left>  :vertical resize -10<CR>
map <leader><Right> :vertical resize +10<CR>

" buffer switch
map gn :bnext<cr>
map gp :bprevious<cr>
map gd :bdelete<cr>

" 配色方案
syntax enable
set background=dark
colorscheme solarized

" 启用 Tab 键补全
set completeopt=menuone,longest
set wildmenu
" set wrap
set rnu
set nu
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set cursorline
set clipboard=unnamed

" ycm
" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'nerdtree' : 1,
      \}

highlight GitGutterAdd    guifg=#ffffff ctermfg=2
highlight GitGutterChange guifg=#ffffff ctermfg=3
highlight GitGutterDelete guifg=#ffffff ctermfg=1
highlight SignColumn ctermbg=NONE
let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'

" git gutter flush time
set updatetime=100