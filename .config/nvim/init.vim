" -----------------
" Plugins and External Utilities
" -------------------------------------------------------------
" Vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
call plug#end()

" Use rg/ag for searching
if executable('rg')
  let g:ctrlp_user_command = 'rg "" --color=never --hidden --files %s'
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s --nocolor --hidden -g ""'
  let g:ackprg = 'ag --vimgrep'
endif

" Use the system clipboard if not using tmux
if $TMUX == ''
  set clipboard+=unnamed
endif

" Toggle Tagbar
nnoremap <leader>t :TagbarToggle<CR>

" Toggle NerdTree
nnoremap <leader>n :NERDTreeToggle<CR>

" -----------------
" Interface
" -------------------------------------------------------------
" Show line numbers
set number

" Wrap lines
set wrap

" Syntax highlighting
syntax enable

" Colors
set t_Co=256
set background=dark
silent! colorscheme dotfiler

" Indent settings
set autoindent

" Tab is equal to 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Highlight current line (slows down scrolling)
"set cursorline

" Show trailing spaces and tabs
set list listchars=tab:│\ ,trail:·

" Folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" Ruler
set colorcolumn=80
"call matchadd('ColorColumn', '\%81v', -1)

" More natural splits
set splitbelow
set splitright
set fillchars=vert:│

" -----------------
" Miscelaneous
" -------------------------------------------------------------
" Unicode support
set encoding=utf-8

" Enable mouse scrollwheel
set mouse=a

" Enable SGR mouse reporting
if has('mouse_sgr')
  set ttymouse=sgr
elseif !has('nvim')
  set ttymouse=xterm2
endif

" Highlight searches
set hlsearch

" Check for file-specific vim settings
set modelines=1

" Search as characters are entered
set incsearch

" Redraw only when necessary
set lazyredraw

" Move temporary files to tmp directory
set bdir-=.
set bdir+=/tmp
set dir-=.
set dir+=/tmp

" Automatically read when file changes
set autoread

" -----------------
" Functions and shortcuts
" -------------------------------------------------------------
" Move to next/previous line with same indentation
nnoremap [b :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap ]b :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>

" Move cursor by display line (rather than physical line)
nnoremap k gk
nnoremap j gj
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

" Jump between if, else, do, case, when, end, etc. in ruby code
runtime macros/matchit.vim
