syntax enable 
" set inchighlight
" colorscheme morning
filetype plugin on
"
" "Information on the following setting can be found with
" ":help set
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4                            	  				"	this is the level of autoindent, adjust to taste
set ruler
set hlsearch 			                              			" used to highlight the searched word
" set number norelativenumber
set rnu                                     	  				" set relativenumber
set number
set visualbell 		                              				" turning of the beep sound on the text edit
" " Uncomment below to make screen not flash on error
" set vb t_vb=""
set nofixendofline                          	    			" save the file without the end of line charactor

" enter the current millinium
set nocompatible

set t_Co=256
set termguicolors

set laststatus=2
set paste                                   	  				" keep the proper formating while pasting on vim"
set backspace=indent,eol,start					        		" fix the backspace issues


set cursorline 									                " this code is to high light the current line on vim
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
" highlight CursorLine guibg=#303000 ctermbg=234

" FINDING FILES:

" Search down into subfolders
" Provideds tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDERS:
" - :b lets you autocomplet any open buffer

