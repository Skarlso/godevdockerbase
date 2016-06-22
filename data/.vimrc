set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'

Bundle 'jistr/vim-nerdtree-tabs'

Plugin 'tpope/vim-fugitive'

Plugin 'fatih/vim-go'

Plugin 'Valloric/YouCompleteMe'

Plugin 'ekalinin/Dockerfile.vim'

Bundle 'elentok/plaintasks.vim'

Plugin 'scrooloose/syntastic'

Plugin 'bling/vim-airline'

Plugin 'scrooloose/nerdcommenter'

Plugin 'majutsushi/tagbar'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set expandtab

" " Nerdtree, vim-go settings
let g:nerdtree_tabs_open_on_console_startup=1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:go_fmt_command = "goimports"
let g:NERDTreeDirArrows = 0

" " Apperance settings: line number, highlight search color and tags.
set number
set hlsearch
set t_Co=256
set tags=~/.vimtags
set encoding=utf-8

" " Schema and colors
syntax on
colorscheme onedark

" " Key mappings
nmap <F8> :TagbarToggle<CR>
nmap <F10> :UpdateTags<CR>
nmap <C-n> :NERDTreeToggle<CR>
nmap <F7> :tabnew<CR>
