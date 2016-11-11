" Modified version of JonSkanes' tabline
" http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line

if exists("+showtabline")
  function MyTabLine()
    let line = ''

    " Loop through each tab
    for tab_index in range(tabpagenr('$'))

      " Highlight tab
      let line .= tab_index + 1 == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

      let line .= ' '
      let mod_count = 0
      let tab_name = ''

      " Set tab index for mouse clicks
      let line .= '%' . (tab_index + 1) . 'T'

      " Add tab index
      let line .= (tab_index + 1) . ' '

      " Add each buffer to tab name
      let buf_count = len(tabpagebuflist(tab_index + 1))
      for buf in tabpagebuflist(tab_index + 1)

        " Count the number of modified buffers
        if getbufvar( buf, "&modified" )
          let mod_count += 1
        endif

        " Add buffer name/type:
        if getbufvar( buf, "&buftype" ) == 'help'
          " Help gets [H]{base fname}
          let tab_name .= '[H]' . fnamemodify( bufname(buf), ':t:line/.txt$//' )
        elseif getbufvar( buf, "&buftype" ) == 'quickfix'
          " Quickfix gets a [Q]
          let tab_name .= '[Q]'
        else
          " Others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
          let tab_name .= pathshorten(bufname(buf))
        endif

        " Separate buffer names
        if buf_count > 1
          let tab_name .= ' '
        endif
        let buf_count -= 1
      endfor

      " Append '[+mod_count]' if a tab has modified buffers
      if mod_count > 1
        let line .= '[+' . mod_count . ']'
      elseif mod_count > 0
        let line .= '[+]'
      endif
      let line .= ' '

      " Append tab name to line
      let line .= tab_name == '' ? '[No Name]' : tab_name
      let line .= ' '
    endfor

    " After the last tab, fill with TabLineFill and reset tab nr
    let line .= '%#TabLineFill#%T'

    " Right-align the 'X' (close) label
    if tabpagenr('$') > 1
      let line .= '%=%#TabLine#%999XX'
    endif
    return line
  endfunction
  set tabline=%!MyTabLine()
endif
