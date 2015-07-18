syntax on 
set number
set tabstop=4
set shiftwidth=4
set scrolloff=5
set autoindent
"set mouse=a

"colorscheme twilight
colorscheme desert

set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

set list
"set listchars=tab:>-,eol:$
set listchars=tab:▸\ ,eol:¬

highlight OverLength ctermbg=6 ctermfg=black guibg=#592929
match OverLength /\%81v.\+/
set colorcolumn=80
highlight colorcolumn ctermbg=6 ctermfg=black

highlight trailing_whitespace ctermbg=red guibg=red
match trailing_whitespace /\s\+$/
