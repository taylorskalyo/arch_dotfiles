" -----------------
" Plugins and External Utilities
" -------------------------------------------------------------
" Vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'ctrlpvim/ctrlp.vim',     { 'on': ['CtrlP', 'CtrlPBuffer'] }
Plug 'mileszs/ack.vim',        { 'on': 'Ack' }
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree',    { 'on': 'NERDTreeToggle' }
Plug 'w0rp/ale',
Plug 'majutsushi/tagbar',      { 'on': 'TagbarToggle' }
Plug 'godlygeek/tabular',      { 'on': 'Tabularize' }
Plug 'fatih/vim-go',           { 'for': 'go' }
Plug 'unblevable/quick-scope'
Plug 'junegunn/goyo.vim',      { 'on' : 'Goyo'}
Plug 'junegunn/limelight.vim', { 'on' : 'Limelight' }
call plug#end()

" Use rg/ag for searching
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --color=never --no-ignore --glob "!.git/*" --hidden --files'
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s --nocolor --ignore ".git/*" --hidden -g ""'
  let g:ackprg = 'ag --vimgrep'
endif

" Only highlight quick-scope targets on character motions
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Highlight markdown code blocks
let g:markdown_fenced_languages = [
      \ 'ruby',
      \ 'go',
      \ 'sh', 'bash=sh', 'shell=sh',
      \ 'javascript', 'js=javascript', 'json'
      \]

" Only lint in normal mode
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'

let g:ale_linters_sh_shellcheck_exclusions = 'SC1090,SC1091'

" Start/Stop Limelight with Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Use the system clipboard if not using tmux
if $TMUX ==? ''
  set clipboard+=unnamed
endif

" Toggle Tagbar
nnoremap <leader>t :TagbarToggle<CR>

" Toggle NerdTree
nnoremap <leader>n :NERDTreeToggle<CR>

" Because we're lazy-loading CtrlP, we need to manually set up this mapping
nnoremap <C-p> :CtrlP<CR>

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
silent! colorscheme terminal

" Indent settings
set autoindent

" Tab is equal to 2 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Highlight current line (can slow down scrolling)
"set cursorline

" Show tabs and trailing spaces
set list listchars=tab:│\ ,trail:·

" Folding
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
" Functions and shortcuts
" -------------------------------------------------------------
" Move cursor by display line (rather than physical line)
nnoremap k gk
nnoremap j gj
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

" Toggle search highlighting
nnoremap <leader>h :set hlsearch! hlsearch?<CR>

" Easier buffer switching (mimics tab switching)
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>

" -----------------
" Miscellaneous
" -------------------------------------------------------------
" Unicode support
set encoding=utf-8

" Enable mouse scroll wheel
set mouse=a

" Do not highlight searches
set nohlsearch

" Search as characters are entered
set incsearch

" Redraw only when necessary
set lazyredraw

" Move temporary files to tmp directory
set backupdir-=.
set backupdir+=/tmp
set directory-=.
set directory+=/tmp

" Automatically read when file changes outside of vim
set autoread

" Allow modified buffers to be hidden
set hidden

" Per-project .nvimrc
set exrc

" Don't run unsafe autocmds in per-project .nvimrc files
set secure

scriptencoding iso-8859-5
