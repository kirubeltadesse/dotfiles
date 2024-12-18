" The default plugin directory will be as follows:
call plug#begin()
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" enable multiple cursors on vim https://github.com/terryma/vim-multiple-cursors
Plug 'terryma/vim-multiple-cursors'

" Install vim-grammarous getting error 122
" Plug 'rhysd/vim-grammarous'
" Plug 'https://github.com/rhysd/vim-grammarous/'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" On-demand loading
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" this appends a directory tothe current runtime path 
set rtp+=~/.fzf


"Autocomplete plugin. similar to VSCoded
" Conflicting with Multiple curse
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" commandline inside vim
Plug 'preservim/vimux'

" Install Dracula for vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim',{'as':'dracula'}


" pandoc on readme file inside vim
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" let b:thisdir=expand("%:p:h")
" let b:vim=b:thisdir."/.vimrc"
execute "source $HOME/.dotfiles/runcom/.vimrc"
set nocompatible              " be iMproved, required
filetype off                  " required

" Brief help
" :PlugInstall    - installs plugins; append `!` to update or just :PlugUpdate
"

syntax on

let g:color_name = 'dracula'
colorscheme dracula
" set inchighlight
" TODO: add a keyboard binding for the vim $(fzf) search  

" enable fzf buffer 
" enable preview for fzf using BAT 
" "Information on the following setting can be found with
" ":help set
" set backspace=indent,eol,start

let g:vimwiki_filetypes = ['markdown']
let g:vimwiki_folding = 'custom'
let g:pandoc#folding#mode = 'stacked'
let g:pandoc#modules#enabled = ['folding', 'command']

" For moving lines (^] is a special character; use <M-k> and <M-j> if it works)
nnoremap <Esc>k :m .-2<CR>==
nnoremap <Esc>j :m .+1<CR>==
inoremap <Esc>j <Esc>:m .+1<CR>==gi
inoremap <Esc>k <Esc>:m .-2<CR>==gi
vnoremap <Esc>j :m '>+1<CR>gv=gv
vnoremap <Esc>k :m '<-2<CR>gv=gv

" Open Vim in a new tab always
" autocmd VimEnter * if !argc() | tabnew | endif

" Optional: Open files in new tabs if they are passed as arguments
" autocmd VimEnter * if argc() > 1 | tab all | endif


" Tabs use nerdtree gt and gp command
nnoremap <C-l>h :tabr<cr>
nnoremap <C-l>j :tabp<cr>
nnoremap <C-l>l :tabl<cr>
" nnoremap <C-tab> :tabn<cr>
nnoremap <C-x> :tabc<cr>
" nnoremap <C-t> :tabnew<cr> "FIXME: this is begin used for nertree
" nnoremap <C-c> :tabc<cr>
nnoremap <C-c> :tabnew<cr>

" remap from ThePrimeagon
xnoremap <Leader>p, _dP


" Map Fzf file finder 
nnoremap <Leader>f :Files<CR> 
" search git files
nnoremap <C-p> :GFiles<Cr> 
" search open buffers
nnoremap <silent><leader>l :Buffers<CR>

" Ensure environment variables are set in Vim
let $FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
let $FZF_DEFAULT_OPTS = '--preview="bat --style=numbers --color=always --line-range :500 {}" --bind alt-j:preview-down,alt-k:preview-up,alt-d:preview-page-down,alt-u:preview-page-up'
let $FZF_DEFAULT_OPS = '--extended'
let $FZF_CTRL_T_COMMAND = $FZF_DEFAULT_COMMAND

" TODO: shortcut conflict between NERDTree and multiplecursor
let g:multi_cursor_use_default_mapping=0

" Note: this command below has already been set 
" Default mapping 
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>' " TODO: need to fix alt key
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


" NERDTree shortcuts
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" conflict nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Enabling custom key bindings
noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>

" this next line is needed to enable your custom colors:
syntax enable

"  vim foreground and background colors
" highlight Comment ctermbg=Blue ctermfg=White

" vim font attribules
" highlight Comment cterm=underline ctermbg=Blue ctermfg=White
" enable global LanguageTool command
let g:grammarous#languagetool_cmd = 'languagetool'

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

" powerline symbols manuel definition
let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.dirty='⚡'
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


" add for multiple_cursors to prevent conflict with Neocomplete
function! Multiple_cursors_before()
      if exists(':NeoCompleteLock')==2
              exe 'NeoCompleteLock'
                endif
endfunction

function! Multiple_cursors_after()
      if exists(':NeoCompleteUnlock')==2
              exe 'NeoCompleteUnlock'
                endif
endfunction

" setting this for htitle() function
let g:HRULEWIDTH = 80


