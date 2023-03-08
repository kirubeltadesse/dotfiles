call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Install vim-grammarous getting error 122
" Plug 'rhysd/vim-grammarous'
" Plug 'https://github.com/rhysd/vim-grammarous/'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

" installing fzf 
" set rtp+=~/.fzf
" Plug '~/.fzf'
" 

"Autocomplete plugin. similar to VSCode
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

" commandline inside vim
Plug 'preservim/vimux'

" Install Dracula for vim

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'dracula/vim',{'name':'dracula'}

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting


set nocompatible              " be iMproved, required
filetype off                  " required
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
colorscheme dracula
filetype plugin indent on

"  set inchighlight

" TODO: add a keyboard binding for the vim $(fzf) search  

" enable fzf buffer 

" enable preview for fzf using BAT 
" "Information on the following setting can be found with
" ":help set
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4  	   " this is the level of autoindent, adjust to taste
set ruler
set hlsearch 			" used to highlight the searched word 
set number relativenumber  " better than set rnu or set relativenumber
set rnu   " set relativenumber

" set number
set visualbell "turning of the beep sound on the text edit
" set backspace=indent,eol,start
" " Uncomment below to make screen not flash on error
" set vb t_vb=""
" "
" " From training
" set nocompatible
"

set nofixendofline " save the file without the end of line charactor

set t_Co=256
set laststatus=2

" Tabs use nerdtree gt and gp command
" nnoremap <C-l>h :tabr<cr>
" nnoremap <C-l>l :tabl<cr>
" nnoremap <C-l>j :tabp<cr>
" nnoremap <C-n> :tabn<cr>
" nnoremap <C-t> :tabnew<cr>
" nnoremap <C-c> :tabc<cr>

" NERDTree shortcuts
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Enabling custom key bindings
noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

" how to configure vim color settings
" highlight Comment ctermbg=DarkGray
" highlight Constant ctermbg=Blue
" highlight Normal ctermbg=Black
" highlight NonText ctermbg=Black
" highlight Special ctermbg=DarkMagenta
" highlight Cursor ctermbg=Green

" this next line is needed to enable your custom colors:
syntax enable

"  vim foreground and background colors
" highlight Comment ctermbg=Blue ctermfg=White

" vim font attribules
" highlight Comment cterm=underline ctermbg=Blue ctermfg=White
" enable global LanguageTool command
let g:grammarous#languagetool_cmd = 'languagetool'

" Airline-tmuxline
"let g:airline#extensions#tmuxline#enabled = 1
"let g:tmuxline_powerline_separators = 0
"let g:airline_powerline_fonts = 1
"let g:airline_detect_paste=1
"let g:airline_detect_spell=1

" unicode symbols

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.colnr = ' ㏇:'
let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = ' ␊:'
let g:airline_symbols.linenr = ' ␤:'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols

"let g:airline_left_sep = ''
"let g:airline_left_alt_sep =  ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch =''
"let g:airline_symbols.colnr = ':'
"let g:airline_symbols.readonly =''
"let g:airline_symbols.linenr = ' :'
"let g:airline_symbols.maxlinenr = '☰ '
"let g:airline_symbols.dirty='⚡'
"

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

" Airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#ctrlp#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

set paste "keep the proper formating while pasting on vim"

" NOTE: Leader here is to mean \

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" remap ctrl +v for windows terminal
nnoremap v <c-v>

