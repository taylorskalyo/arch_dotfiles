" Modified version of JonSkanes' tabline
" http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line

if exists("+showtabline")
  function MyTabLine()
    let l:line = ''

    " Loop through each tab
    for l:tab_index in range(tabpagenr('$'))

      " Highlight tab
      let l:line .= (l:tab_index + 1) == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

      let l:line .= ' '
      let l:mod_count = 0
      let l:tab_name = ''

      " Set tab index for mouse clicks
      let l:line .= '%' . (l:tab_index + 1) . 'T'

      " Add tab index
      let l:line .= (l:tab_index + 1) . ' '

      " Add each buffer to tab name
      let l:buf_count = len(tabpagebuflist(l:tab_index + 1))
      for buf in tabpagebuflist(l:tab_index + 1)

        " Count the number of modified buffers
        if getbufvar(l:buf, "&modified")
          let l:mod_count += 1
        endif

        " Add buffer name/type:
        if getbufvar(l:buf, "&buftype") == 'help'
          " Help gets [H]{base fname}
          let l:tab_name .= '[H]' . fnamemodify(bufname(l:buf), ':t:line/.txt$//')
        elseif getbufvar(l:buf, "&buftype") == 'quickfix'
          " Quickfix gets a [Q]
          let l:tab_name .= '[Q]'
        else
          " Others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
          let l:tab_name .= pathshorten(bufname(buf))
        endif

        " Separate buffer names
        if l:buf_count > 1
          let l:tab_name .= ' '
        endif
        let l:buf_count -= 1
      endfor

      " Append '[+mod_count]' if a tab has modified buffers
      if l:mod_count > 1
        let l:line .= '[+' . l:mod_count . '] '
      elseif l:mod_count > 0
        let l:line .= '[+] '
      endif

      " Append tab name to line
      let l:line .= l:tab_name == '' ? '[No Name]' : l:tab_name
      let l:line .= ' '
    endfor

    " After the last tab, fill with TabLineFill and reset tab nr
    let l:line .= '%#TabLineFill#%T'

    " Right-align the 'X' (close) label
    if tabpagenr('$') > 1
      let l:line .= '%=%#TabLine#%999XX'
    endif
    return l:line
  endfunction
  set tabline=%!MyTabLine()
endif
