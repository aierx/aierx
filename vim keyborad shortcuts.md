# VIM快捷键

### 修改配置后 立即更新
![](https://raw.githubusercontent.com/aierx/images/master/1f7c1c354603aae6dd6d573db540d4dc179593.png)
:so

### config .vimrc

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

### tab

:tabnew [++opt选项] ［＋cmd］ 文件 建立对指定文件新的tab

:tabc 关闭当前的tab

:tabo 关闭所有其他的tab

:tabs 查看所有打开的tab

:tabp 前一个

:tabn 后一个

{N}gt 指定哪个

gt  后一个

gT 前一个

### window

| 命令    | 描述                         |
| ------- | ---------------------------- |
| :split  | 新建一个窗口并显示当前文件   |
| :new    | 新建一个窗口并开始新文件     |
| :sview  | 新建一个窗口并只读打开文件   |
| ctrl+Ww | 切换窗口                     |
| ctrl+Wj | 切换至下一窗口               |
| ctrl+Wk | 切换至上一窗口               |
| ctrl+Wt | 切换至顶部的窗口             |
| ctrl+Wb | 切换至底部的窗口             |
| ctrl+Wp | 切换至刚才所在的窗口         |
| ctrl+Wr | 向下循环移动窗口             |
| ctrl+WR | 向上循环移动窗口             |~~~~
| ctrl+Wx | 将当前窗口与下一窗口位置对换 |
| ctrl+WK | 将当前窗口放到最顶端         |
| ctrl+WJ | 将当前窗口放到最底部         |
| ctrl+Wc | 关闭当前窗口                 |
| ctrl+Wo | 关闭其他所有窗口             |
| ctrl+W+ | 增大窗口                     |
| ctrl+W- | 减小窗口                     |
| ctrl+W= | 等分窗口                     |
| Ctrl+W_ | 最大化窗口                   |

1. 垂直分屏：
    - 调整当前窗口宽度：使用命令 Ctrl + w >（增加宽度）和 Ctrl + w <（减小宽度）。
    - 平均调整所有窗口宽度：使用命令 Ctrl + w =。
2. 水平分屏：
    - 调整当前窗口高度：使用命令 Ctrl + w +（增加高度）和 Ctrl + w -（减小高度）。
    - 平均调整所有窗口高度：使用命令 Ctrl + w _。

file

bp 前一个文件

bn 后一个文件

Peg

整页翻页命令

向前翻页：Ctrl + f

向后翻页：Ctrl + b

翻半页命令

向下翻半页：Ctrl + d

向上翻半页：Ctrl + u

滚动一行命令

向下滚动一行：Ctrl + e

向上滚动一行：Ctrl + y

光标位置命令

将光标所在的行居屏幕中央：zz

将光标所在的行居屏幕最上一行：zt

将光标所在的行居屏幕最下一行：zb
