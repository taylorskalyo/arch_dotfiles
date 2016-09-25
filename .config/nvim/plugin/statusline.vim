" Statusline colors
hi User1 ctermfg=9
hi User2 ctermfg=10
hi User3 ctermfg=12
hi User4 ctermfg=13
hi User5 ctermfg=14
hi User6 ctermfg=8
" User7 changes based on the current mode

" Statusline Mode
hi User7 ctermfg=9
function! Mode()
  let l:mode = mode()

  if l:mode ==# "n"
    hi User7 ctermfg=9
    return "  NORMAL "
  elseif l:mode ==# "i"
    hi User7 ctermfg=10
    return "  INSERT "
  elseif l:mode ==# "R"
    hi User7 ctermfg=11
    return "  REPLACE "
  elseif l:mode ==# "v"
    hi User7 ctermfg=12
    return "  VISUAL "
  elseif l:mode ==# "V"
    hi User7 ctermfg=12
    return "  V·LINE "
  elseif l:mode ==# "^V"
    hi User7 ctermfg=12
    return "  V·BLOCK "
  else
    return l:mode
  endif
endfunction

" Statusline content
set laststatus=2
set statusline=%7*%{Mode()}%*    " Mode
set statusline+=%6*%=            " Separator
set statusline+=%4*\ %{&modified?'[+]\ ':''}%.40f       " Filename
set statusline+=%3*%{strlen(&filetype)>0?'\ '.&filetype:''} " Filetype
set statusline+=%5*\ %P          " Percentage through file
set statusline+=%2*\ %-6(%l:%c%) " Line:Col
