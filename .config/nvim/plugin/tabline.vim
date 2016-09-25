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
      let s .= '+ '
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
