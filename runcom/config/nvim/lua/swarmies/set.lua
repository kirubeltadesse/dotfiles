-- syntax enable 
-- vim.opt.inchighlight
-- colorscheme morning
-- filetype plugin on
-- Information on the following setting can be found with
-- :help set
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4                            	  				--	this is the level of autoindent, adjust to taste
vim.opt.expandtab = true
vim.opt.shiftwidth = 4                            	  				--	this is the level of autoindent, adjust to taste

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ruler = true


vim.opt.swapfile = false  

vim.opt.backup = false -- used to highlight the searched word
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false 			                              			-- used to highlight the searched word
vim.opt.incsearch = true 									-- used to highlight incremental in searched word

vim.opt.scrolloff = 8 									-- make sure to have the curser 8 line up/below unless first/lest
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.rnu = true                                    	  				-- set relativenumber
vim.opt.visualbell = true		                              				-- turning of the beep sound on the text edit
-- " Uncomment below to make screen not flash on error
-- vim.opt.vb t_vb=""
--vim.opt.nofixendofline                          	    			-- save the file without the end of line charactor

-- enter the current millinium
-- vim.opt.nocompatible = true

-- vim.opt.t_Co=256

vim.opt.laststatus = 2
-- vim.opt.paste = true                                   	  			-- Massing up with Telescope keep the proper formating while pasting on vim"
-- vim.opt.backspace=indent,eol,start					        		-- fix the backspace issues


vim.opt.cursorline = true 								-- this code is to high light the current line on vim
-- highlight CursorLine guibg=#303000 ctermbg=234

-- FINDING FILES:

-- Search down into subfolders
-- Provideds tab-completion for all file-related tasks
-- vim.opt.path+=**

-- Display all matching files when we tab complete
vim.opt.wildmenu = true

-- NOW WE CAN:
-- - Hit tab to :find by partial match
-- - Use * to make it fuzzy

-- THINGS TO CONSIDERS:
-- - :b lets you autocomplet any open buffer


