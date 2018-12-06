set nocompatible              " be iMproved, required
filetype off                  " required

" I don't install vundle everywhere, skip that if it's not installed
if isdirectory(expand('~/.vim/bundle/Vundle.vim'))
    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')
    """
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'
    " Nice utils for Golang
    Plugin 'fatih/vim-go'
    " Python
    Plugin 'klen/python-mode'
    " Plugins for folding
    Plugin 'Konfekt/FastFold'
    Plugin 'tmhedberg/SimpylFold' " Better folding for python
    """
    call vundle#end()
endif

filetype plugin indent on

syntax on
set number
set tabstop=4
set expandtab
set shiftwidth=4
set scrolloff=5
set autoindent
"set mouse=a

"colorscheme desert
colorscheme elflord
set hlsearch

set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}
highlight StatusLine ctermbg=16 ctermfg=74

highlight OverLength ctermbg=6 ctermfg=black guibg=#592929
match OverLength /\%81v.\+/
set colorcolumn=100
highlight colorcolumn ctermbg=6 ctermfg=black

highlight trailing_whitespace ctermbg=red guibg=red
match trailing_whitespace /\s\+$/

let g:go_version_warning = 0
autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)

function SetPythonOptions()
  set filetype=python
  set syntax=python
endfunction

autocmd BufRead,BufNewFile *.pyst call SetPythonOptions()
