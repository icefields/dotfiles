""" SOURCES
""" https://github.com/junegunn/vim-plug/
""" https://www.youtube.com/watch?v=JWReY93Vl6g
""" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
"""
"""   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄ 
"""  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌
"""  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌
"""  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌
"""  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌
"""  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌
"""   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀ 
"""                                 
""" :PlugClean :PlugInstall :UpdateRemotePlugins
""" cocInstall, install manually coc-java, coc-python, coc-html, etc ...
""" instructions: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
""" :CocInstall coc-python
""" :CocInstall coc-clangd
""" :CocInstall coc-snippets
""" :CocCommand snippets.edit... FOR EACH FILE TYPE
"""

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
" :set relativenumber
:set smarttab

filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

""" --- Plugins ---
""" Dracula : A really good theme for Neovim.
""" Nerdcommenter : An easy way for commenting outlines.
""" Nerdtree : A file explorer for neovim. Netrw comes as default for neovim.
""" Vim-devicons : Devicon support for nerdtree.
""" Ultisnips : ASnippets engine.
""" Vim-snippets : A collection of snippets
""" Vim-startify : A really handy start page with lots of customizations.
""" Coc : A fast code completion engine
""" call plug#begin("~/.vim/plugged")
call plug#begin()
    Plug 'http://github.com/tpope/vim-surround'         " Surrounding ysw)
    " Plug 'https://github.com/preservim/nerdtree'        " NerdTree
    Plug 'scrooloose/nerdtree'                          " NerdTree
    Plug 'https://github.com/tpope/vim-commentary'      " For Commenting gcc & gc
    Plug 'https://github.com/vim-airline/vim-airline'   " Status bar
    Plug 'https://github.com/lifepillar/pgsql.vim'      " PSQL Pluging needs :SQLSetType pgsql.vim
    Plug 'https://github.com/ap/vim-css-color'          " CSS Color Preview
    Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
    " Plug 'https://github.com/neoclide/coc.nvim'         " Auto Completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'https://github.com/ryanoasis/vim-devicons'    " Developer Icons
    Plug 'https://github.com/tc50cal/vim-terminal'      " Vim Terminal
    Plug 'https://github.com/preservim/tagbar'          " Tagbar for code navigation
    Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
    Plug 'dracula/vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'preservim/nerdcommenter'
    Plug 'mhinz/vim-startify'
    
    set encoding=UTF-8
call plug#end()

""" --- MAPPING ---
""" inoremap: maps the key in insert mode
""" nnoremap: maps the key in normal mode
""" vnoremap: maps the key in visual mode
""" <C>: Represents the control key
""" <A>: Represents the alt key.
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-l> :call CocActionAsync('jumpDefinition')<CR>
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
nmap <F8> :TagbarToggle<CR>

" Investigate this 
" :set completeopt-=preview " For No Previews

""" --- COLOUR SCHEME ---
" :colorscheme jellybeans
" :colorscheme fogbell 
" :colorscheme rdark-terminal2
colorscheme nord


""" --- AIRLINE ---
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

