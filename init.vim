" Install vim-plug if it not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Source plugins
call plug#begin()
  source ~/.config/nvim/plugins.vim
call plug#end()

source ~/.config/nvim/plugin_setup.vim

" Remap leader key to ,
let g:mapleader=','
nnoremap <Leader>nn : NERDTreeToggle<cr>
nnoremap <C-D> :bp\|bd #<CR>
inoremap <C-D> <esc>:bp\|bd #<CR>
nnoremap <C-A> ggVGG
vnoremap <C-A> ggVGG
nnoremap <Leader><Space> :nohlsearch<CR>
nnoremap ,, :NERDTreeFind<CR>

set hidden
set number
set noshowcmd
set clipboard=unnamed
set expandtab
set softtabstop=2
set shiftwidth=2
set nowrap
set nocursorline
set shortmess+=c
set mouse=a
set encoding=UTF-8
set relativenumber

let g:python3_host_prog='/usr/bin/python3'

vnoremap <C-c> "+y

let g:indentLine_first_char = '|'
let g:indentLine_char = '|'
let g:indentLine_showFirstIndentLevel = 1

