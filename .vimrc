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
    Plugin 'python-mode/python-mode'
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

function! SetupColorHighlights()
    set colorcolumn=100
    hi ColorColumn ctermfg=black ctermbg=6

    hi TrailingWhitespace ctermbg=red
    match TrailingWhitespace /\s\+$/
endfunction

colorscheme elflord
if ( has('gui_running') ? -1 : (&t_Co ?? 0) >= 256 )
  hi Normal      ctermfg=231   ctermbg=NONE cterm=NONE
  hi EndOfBuffer ctermfg=NONE  ctermbg=None cterm=NONE
  hi StatusLine  ctermfg=227   ctermbg=232  cterm=NONE
  hi LineNr      ctermfg=227   ctermbg=NONE cterm=NONE

  augroup vimrc_autocmds
    au!
    autocmd BufEnter * call SetupColorHighlights()
  augroup END
endif

set hlsearch
set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

let g:go_version_warning = 0
autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)

function SetPythonOptions()
  " Figure out if we actually want this...
  "set filetype=python
  set syntax=python
endfunction

autocmd BufRead,BufNewFile *.pyst call SetPythonOptions()

set backspace=indent,eol,start
