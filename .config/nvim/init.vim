" -----------------
" Plugins and External Utilities
" -------------------------------------------------------------
" Vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'rust-lang/rust.vim'
call plug#end()

" Speed up CtrlP
if executable('rg')
  let g:ctrlp_user_command = 'rg "" --color=never --hidden --files %s'
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s --nocolor --hidden -g ""'
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

" Tabline
hi TabLine ctermfg=0 ctermbg=7
hi TabLineFill ctermfg=0 ctermbg=7

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
if has("mouse_sgr")
  set ttymouse=sgr
elseif !has("nvim")
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

" -----------------
" Numbered tabs
" -------------------------------------------------------------
set tabline=%!MyTabLine()
function MyTabLine()
  let s = ''
  " Loop through each tab page
  for t in range(tabpagenr('$'))
    " Select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= ' '
    " Set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " Set page number string
    let s .= t + 1 . ' '
    " Get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let m = 0 " &modified counter
    let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
    " Loop through each buffer in a tab
    for b in tabpagebuflist(t + 1)
      " Buffer types: quickfix gets a [Q], help gets [H]{base fname}
      " Others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
      if getbufvar( b, "&buftype" ) == 'help'
        let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
      elseif getbufvar( b, "&buftype" ) == 'quickfix'
        let n .= '[Q]'
      else
        let n .= pathshorten(bufname(b))
      endif
      " Check and ++ tab's &modified count
      if getbufvar( b, "&modified" )
        let m += 1
      endif
      if bc > 1
        let n .= ' '
      endif
      let bc -= 1
    endfor
    " Add modified label [n+] where n pages in tab are modified
    if m > 0
      let s.= '+ '
    endif
    " Add buffer names
    if n == ''
      let s .= '[No Name]'
    else
      let s .= n
    endif
    let s .= ' '
  endfor
  " After the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " Right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction

" -----------------
" Statusline
" -------------------------------------------------------------
" Statusline colors
hi User1 ctermfg=9  " Red
hi User2 ctermfg=10 " Green
hi User3 ctermfg=11 " Yellow
hi User4 ctermfg=12 " Blue
hi User5 ctermfg=13 " Magenta
hi User6 ctermfg=14 " Cyan
hi User7 ctermfg=7  " White
hi User8 ctermfg=8  " Black
" User9 changes based on the current mode

" Statusline Mode
hi User9 ctermfg=9
let g:last_mode = ''
function! Mode()
  let l:mode = mode()

  if l:mode !=# g:last_mode
    let g:last_mode = l:mode

    if l:mode ==# 'n'
      hi User9 ctermfg=9 " Red
    elseif l:mode ==# "i"
      hi User9 ctermfg=10 " Green
    elseif l:mode ==# "R"
      hi User9 ctermfg=11 " Yellow
    elseif l:mode ==? "v" || l:mode ==# "^V"
      hi User9 ctermfg=12 " Blue
    endif
  endif

  if l:mode ==# "n"
    return "  NORMAL "
  elseif l:mode ==# "i"
    return "  INSERT "
  elseif l:mode ==# "R"
    return "  REPLACE "
  elseif l:mode ==# "v"
    return "  VISUAL "
  elseif l:mode ==# "V"
    return "  V·LINE "
  elseif l:mode ==# "^V"
    return "  V·BLOCK "
  else
    return l:mode
  endif
endfunction

" Statusline content
set laststatus=2
set statusline=
set statusline=%9*%{Mode()}%* " Mode
set statusline+=%8*
set statusline+=%=            " Separator
set statusline+=%5*
set statusline+=\ %.40f       " Filename
set statusline+=%4*
set statusline+=%{strlen(&filetype)>0?'\ '.&filetype:''} " Filetype
set statusline+=%6*
set statusline+=\ %P          " Percentage through file
set statusline+=%2*
set statusline+=\ %-6(%l:%c%) " Line:Col
