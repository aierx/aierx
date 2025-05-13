
# tab

| 命令                     | 描述                       |
| ------------------------ | -------------------------- |
| :tabnew [++opt] ［+cmd］ | 文件 建立对指定文件新的tab |
| :tabc                    | 关闭当前的tab              |
| :tabo                    | 关闭所有其他的tab          |
| :tabs                    | 查看所有打开的tab          |
| :tabp                    | 前一个                     |
| :tabn                    | 后一个                     |
| {N}gt                    | 指定哪个                   |
| gt                       | 后一个                     |
| gT                       | 前一个                     |

# window

| 命令                   | 描述                         |
| ---------------------- | ---------------------------- |
| :sp                    | 水平分屏                     |
| :vsp                   | 垂直分屏                     |
| :new                   | 新建一个窗口并开始新文件     |
| :sview                 | 新建一个窗口并只读打开文件   |
| <ctrl+w> w             | 切换窗口                     |
| <ctrl+w> j             | 切换至下一窗口               |
| <ctrl+w> k             | 切换至上一窗口               |
| <ctrl+w> t             | 切换至顶部的窗口             |
| <ctrl+w> b             | 切换至底部的窗口             |
| <ctrl+w> p             | 切换之前所在的窗口           |
| <ctrl+w> r             | 向下循环移动窗口             |
| <ctrl+w> R             | 向上循环移动窗口             |
| <ctrl+w> x             | 将当前窗口与下一窗口位置对换 |
| <ctrl+w> K             | 将当前窗口放到最顶端         |
| <ctrl+w> J             | 将当前窗口放到最底部         |
| <ctrl+w> c             | 关闭当前窗口                 |
| <ctrl+w> o             | 关闭其他所有窗口             |
| {n} <ctrl+w> +         | 增大窗口                     |
| {n} <ctrl+w> >         | 增大窗口                     |
| {n} <ctrl+w> -         | 减小窗口                     |
| {n} <ctrl+w> <         | 减小窗口                     |
| <ctrl+W> =             | 等分窗口                     |
| <Ctrl+W> _             | 竖向最大化窗口                   |
| <Ctrl+W> \|            | 横向最大化窗口                   |
| : [horizontal] res {n} | 设置垂直方向宽度             |
| : vertical {n}         | 设置水平方向宽度             |

# buffer

| 命令                | 描述                         |
| ------------------- | ---------------------------- |
| :ls                 | 列出buffer                   |
| :file               | 列出buffer                   |
| :buffers            | 列出buffer                   |
| : b [no] [filename] | 切换到指定buffer             |
| bp                  | 前一个文件                   |
| bn                  | 后一个文件                   |
| Peg                 | 整页翻页命令                 |
| Ctrl + f            | 向前翻页                     |
| Ctrl + b            | 向后翻页                     |
| Ctrl + d            | 向下翻半页                   |
| Ctrl + u            | 向上翻半页                   |
| Ctrl + e            | 向下滚动一行                 |
| Ctrl + y            | 向上滚动一行                 |
| zz                  | 将光标所在的行居屏幕中央     |
| zt                  | 将光标所在的行居屏幕最上一行 |
| zb                  | 将光标所在的行居屏幕最下一行 |

#register
| 命令   | 描述               |
| ------ | ------------------ |
| "{n}yy | 复制到指定寄存器   |
| "{n}p  | 从指定寄存器粘贴   |
| reg    | 查看当前所有寄存器 |

# macro
| 命令     | 描述                                     |
| -------- | ---------------------------------------- |
| q{n}...q | 录制宏，...代表执行的操作                |
| {n}@{n}  | 第一个n代表执行次数，第二个是录制使用的n |


# config .vimrc

``` shell
call plug#begin('~/.vim/plugged')
" 状态栏
Plug 'itchyny/lightline.vim'
" 代码提示
Plug 'valloric/youcompleteme'
" 目录栏
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
" 文件搜索
Plug 'junegunn/fzf',{ 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" 多光标
Plug 'terryma/vim-multiple-cursors'
" git 
Plug 'airblade/vim-gitgutter'
" git cimdiff
Plug 'chrisbra/vim-diff-enhanced'
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

map <leader>w  :w<cr>
map <leader>q    :wq<CR>
map <leader>Q   :q!<CR>
map <leader>t  :terminal<CR>
map <leader>d   :set splitright<CR>:vsplit<CR>
map <leader>s   :set nosplitbelow<CR>:split<CR>
map <leader>F    :Files<CR>
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

```
