if has('statusline')
  " Statusline Mode
  hi User1 ctermfg=9
  function! Mode()
    let l:mode = mode()

    if l:mode ==# "n"
      hi User1 ctermfg=9
      return "  NORMAL "
    elseif l:mode ==# "i"
      hi User1 ctermfg=10
      return "  INSERT "
    elseif l:mode ==# "R"
      hi User1 ctermfg=11
      return "  REPLACE "
    elseif l:mode ==# "v"
      hi User1 ctermfg=12
      return "  VISUAL "
    elseif l:mode ==# "V"
      hi User1 ctermfg=12
      return "  V·LINE "
    elseif l:mode ==# "^V"
      hi User1 ctermfg=12
      return "  V·BLOCK "
    else
      return l:mode
    endif
  endfunction

  " Statusline content
  set laststatus=2
  set statusline=%1*
  set statusline+=%{Mode()}                                " Mode
  set statusline+=%*
  set statusline+=%=                                       " Separator
  set statusline+=%#Structure#
  set statusline+=\ %{&modified?'[+]\ ':''}%.40f           " Filename
  set statusline+=%#Type#
  set statusline+=%{strlen(&filetype)>0?'\ '.&filetype:''} " Filetype
  set statusline+=%#Operator#
  set statusline+=\ %P                                     " Scroll location
  set statusline+=%#MoreMsg#
  set statusline+=\ %-6(%l:%c%)                            " Line:Col
endif
