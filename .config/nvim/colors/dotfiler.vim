" Modified from the theme "Tomorrow Night"

" Hex colour conversion functions borrowed from the theme "Desert256"

" Colors
let s:foreground = "c5c8c6"
let s:background = "262626"
let s:selection  = "585858"
let s:line       = "343434"
let s:comment    = "969896"
let s:color1     = "cc6666"
let s:color2     = "b5bd68"
let s:color3     = "de935f"
let s:color4     = "81a2be"
let s:color5     = "b294bb"
let s:color6     = "8abeb7"
let s:color11    = "f0c674"
let s:window     = "5e5e5e"

hi clear
syntax reset

let g:colors_name = "dotfiler"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
  " Returns an approximate grey index for the given grey level
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " Returns the palette index for the given grey index
  fun <SID>grey_colour(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 232 + a:n
      endif
    endif
  endfun

  " Returns an approximate colour index for the given colour level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " Returns the actual colour level for the given colour index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " Returns the palette index for the given R/G/B colour indices
  fun <SID>rgb_colour(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " Returns the palette index to approximate the given R/G/B colour levels
  fun <SID>colour(r, g, b)
    " Get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " Get the closest colour
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " There are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " Use the grey
        return <SID>grey_colour(l:gx)
      else
        " Use the colour
        return <SID>rgb_colour(l:x, l:y, l:z)
      endif
    else
      " Only one possibility
      return <SID>rgb_colour(l:x, l:y, l:z)
    endif
  endfun

  " Returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

    return <SID>colour(l:r, l:g, l:b)
  endfun

  " Sets the highlighting for the given group
  fun <SID>X(group, fg, bg, attr)
    if a:fg != ""
      exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
    endif
    if a:bg != ""
      exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
    endif
    if a:attr != ""
      exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
  endfun

  " Vim Highlighting
  call <SID>X("Normal", s:foreground, s:background, "")
  call <SID>X("LineNr", s:selection, "", "")
  call <SID>X("NonText", s:selection, "", "")
  call <SID>X("SpecialKey", s:selection, "", "")
  call <SID>X("Search", s:background, s:color11, "")
  call <SID>X("TabLine", s:line, s:foreground, "reverse")
  call <SID>X("TabLineFill", s:line, s:foreground, "reverse")
  call <SID>X("StatusLine", s:background, s:color11, "reverse")
  call <SID>X("StatusLineNC", s:line, s:foreground, "reverse")
  call <SID>X("VertSplit", s:window, s:background, "none")
  call <SID>X("Visual", "", s:selection, "")
  call <SID>X("Directory", s:color4, "", "")
  call <SID>X("ModeMsg", s:color2, "", "")
  call <SID>X("MoreMsg", s:color2, "", "")
  call <SID>X("Question", s:color2, "", "")
  call <SID>X("WarningMsg", s:color1, "", "")
  call <SID>X("MatchParen", "", s:selection, "")
  call <SID>X("Folded", s:comment, s:background, "")
  call <SID>X("FoldColumn", "", s:background, "")
  if version >= 700
    call <SID>X("CursorLine", "", s:line, "none")
    call <SID>X("CursorColumn", "", s:line, "none")
    call <SID>X("PMenu", s:foreground, s:selection, "none")
    call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
    call <SID>X("SignColumn", "", s:background, "none")
  end
  if version >= 703
    call <SID>X("ColorColumn", "", s:line, "none")
  end

  " Standard Highlighting
  call <SID>X("Comment", s:comment, "", "")
  call <SID>X("Todo", s:comment, s:background, "")
  call <SID>X("Title", s:comment, "", "")
  call <SID>X("Identifier", s:color1, "", "none")
  call <SID>X("Statement", s:foreground, "", "")
  call <SID>X("Conditional", s:foreground, "", "")
  call <SID>X("Repeat", s:foreground, "", "")
  call <SID>X("Structure", s:color5, "", "")
  call <SID>X("Function", s:color4, "", "")
  call <SID>X("Constant", s:color3, "", "")
  call <SID>X("Keyword", s:color3, "", "")
  call <SID>X("String", s:color2, "", "")
  call <SID>X("Special", s:foreground, "", "")
  call <SID>X("PreProc", s:color5, "", "")
  call <SID>X("Operator", s:color6, "", "none")
  call <SID>X("Type", s:color4, "", "none")
  call <SID>X("Define", s:color5, "", "none")
  call <SID>X("Include", s:color4, "", "")
  "call <SID>X("Ignore", "666666", "", "")

  " Vim Highlighting
  call <SID>X("vimCommand", s:color1, "", "none")

  " C Highlighting
  call <SID>X("cType", s:color11, "", "")
  call <SID>X("cStorageClass", s:color5, "", "")
  call <SID>X("cConditional", s:color5, "", "")
  call <SID>X("cRepeat", s:color5, "", "")

  " PHP Highlighting
  call <SID>X("phpVarSelector", s:color1, "", "")
  call <SID>X("phpKeyword", s:color5, "", "")
  call <SID>X("phpRepeat", s:color5, "", "")
  call <SID>X("phpConditional", s:color5, "", "")
  call <SID>X("phpStatement", s:color5, "", "")
  call <SID>X("phpMemberSelector", s:foreground, "", "")

  " Ruby Highlighting
  call <SID>X("rubySymbol", s:color2, "", "")
  call <SID>X("rubyConstant", s:color11, "", "")
  call <SID>X("rubyAccess", s:color11, "", "")
  call <SID>X("rubyAttribute", s:color4, "", "")
  call <SID>X("rubyInclude", s:color4, "", "")
  call <SID>X("rubyLocalVariableOrMethod", s:color3, "", "")
  call <SID>X("rubyCurlyBlock", s:color3, "", "")
  call <SID>X("rubyStringDelimiter", s:color2, "", "")
  call <SID>X("rubyInterpolationDelimiter", s:color3, "", "")
  call <SID>X("rubyConditional", s:color5, "", "")
  call <SID>X("rubyRepeat", s:color5, "", "")
  call <SID>X("rubyControl", s:color5, "", "")
  call <SID>X("rubyException", s:color5, "", "")

  " Crystal Highlighting
  call <SID>X("crystalSymbol", s:color2, "", "")
  call <SID>X("crystalConstant", s:color11, "", "")
  call <SID>X("crystalAccess", s:color11, "", "")
  call <SID>X("crystalAttribute", s:color4, "", "")
  call <SID>X("crystalInclude", s:color4, "", "")
  call <SID>X("crystalLocalVariableOrMethod", s:color3, "", "")
  call <SID>X("crystalCurlyBlock", s:color3, "", "")
  call <SID>X("crystalStringDelimiter", s:color2, "", "")
  call <SID>X("crystalInterpolationDelimiter", s:color3, "", "")
  call <SID>X("crystalConditional", s:color5, "", "")
  call <SID>X("crystalRepeat", s:color5, "", "")
  call <SID>X("crystalControl", s:color5, "", "")
  call <SID>X("crystalException", s:color5, "", "")

  " Python Highlighting
  call <SID>X("pythonInclude", s:color5, "", "")
  call <SID>X("pythonStatement", s:color5, "", "")
  call <SID>X("pythonConditional", s:color5, "", "")
  call <SID>X("pythonRepeat", s:color5, "", "")
  call <SID>X("pythonException", s:color5, "", "")
  call <SID>X("pythonFunction", s:color4, "", "")
  call <SID>X("pythonPreCondit", s:color5, "", "")
  call <SID>X("pythonRepeat", s:color6, "", "")
  call <SID>X("pythonExClass", s:color3, "", "")

  " JavaScript Highlighting
  call <SID>X("javaScriptBraces", s:foreground, "", "")
  call <SID>X("javaScriptFunction", s:color5, "", "")
  call <SID>X("javaScriptConditional", s:color5, "", "")
  call <SID>X("javaScriptRepeat", s:color5, "", "")
  call <SID>X("javaScriptNumber", s:color3, "", "")
  call <SID>X("javaScriptMember", s:color3, "", "")
  call <SID>X("javascriptNull", s:color3, "", "")
  call <SID>X("javascriptGlobal", s:color4, "", "")
  call <SID>X("javascriptStatement", s:color1, "", "")

  " CoffeeScript Highlighting
  call <SID>X("coffeeRepeat", s:color5, "", "")
  call <SID>X("coffeeConditional", s:color5, "", "")
  call <SID>X("coffeeKeyword", s:color5, "", "")
  call <SID>X("coffeeObject", s:color11, "", "")

  " HTML Highlighting
  call <SID>X("htmlTag", s:color1, "", "")
  call <SID>X("htmlTagName", s:color1, "", "")
  call <SID>X("htmlArg", s:color1, "", "")
  call <SID>X("htmlScriptTag", s:color1, "", "")

  " Diff Highlighting
  call <SID>X("diffAdd", "", "4c4e39", "")
  call <SID>X("diffDelete", s:background, s:color1, "")
  call <SID>X("diffChange", "", "2B5B77", "")
  call <SID>X("diffText", s:line, s:color4, "")

  " ShowMarks Highlighting
  call <SID>X("ShowMarksHLl", s:color3, s:background, "none")
  call <SID>X("ShowMarksHLo", s:color5, s:background, "none")
  call <SID>X("ShowMarksHLu", s:color11, s:background, "none")
  call <SID>X("ShowMarksHLm", s:color6, s:background, "none")

  " Lua Highlighting
  call <SID>X("luaStatement", s:color5, "", "")
  call <SID>X("luaRepeat", s:color5, "", "")
  call <SID>X("luaCondStart", s:color5, "", "")
  call <SID>X("luaCondElseif", s:color5, "", "")
  call <SID>X("luaCond", s:color5, "", "")
  call <SID>X("luaCondEnd", s:color5, "", "")

  " Cucumber Highlighting
  call <SID>X("cucumberGiven", s:color4, "", "")
  call <SID>X("cucumberGivenAnd", s:color4, "", "")

  " Go Highlighting
  call <SID>X("goDirective", s:color5, "", "")
  call <SID>X("goDeclaration", s:color5, "", "")
  call <SID>X("goStatement", s:color5, "", "")
  call <SID>X("goConditional", s:color5, "", "")
  call <SID>X("goConstants", s:color3, "", "")
  call <SID>X("goTodo", s:color11, "", "")
  call <SID>X("goDeclType", s:color4, "", "")
  call <SID>X("goBuiltins", s:color5, "", "")
  call <SID>X("goRepeat", s:color5, "", "")
  call <SID>X("goLabel", s:color5, "", "")

  " Clojure Highlighting
  call <SID>X("clojureConstant", s:color3, "", "")
  call <SID>X("clojureBoolean", s:color3, "", "")
  call <SID>X("clojureCharacter", s:color3, "", "")
  call <SID>X("clojureKeyword", s:color2, "", "")
  call <SID>X("clojureNumber", s:color3, "", "")
  call <SID>X("clojureString", s:color2, "", "")
  call <SID>X("clojureRegexp", s:color2, "", "")
  call <SID>X("clojureParen", s:color6, "", "")
  call <SID>X("clojureVariable", s:color11, "", "")
  call <SID>X("clojureCond", s:color4, "", "")
  call <SID>X("clojureDefine", s:color5, "", "")
  call <SID>X("clojureException", s:color1, "", "")
  call <SID>X("clojureFunc", s:color4, "", "")
  call <SID>X("clojureMacro", s:color4, "", "")
  call <SID>X("clojureRepeat", s:color4, "", "")
  call <SID>X("clojureSpecial", s:color5, "", "")
  call <SID>X("clojureQuote", s:color4, "", "")
  call <SID>X("clojureUnquote", s:color4, "", "")
  call <SID>X("clojureMeta", s:color4, "", "")
  call <SID>X("clojureDeref", s:color4, "", "")
  call <SID>X("clojureAnonArg", s:color4, "", "")
  call <SID>X("clojureRepeat", s:color4, "", "")
  call <SID>X("clojureDispatch", s:color4, "", "")

  " Scala Highlighting
  call <SID>X("scalaKeyword", s:color5, "", "")
  call <SID>X("scalaKeywordModifier", s:color5, "", "")
  call <SID>X("scalaOperator", s:color4, "", "")
  call <SID>X("scalaPackage", s:color1, "", "")
  call <SID>X("scalaFqn", s:foreground, "", "")
  call <SID>X("scalaFqnSet", s:foreground, "", "")
  call <SID>X("scalaImport", s:color5, "", "")
  call <SID>X("scalaBoolean", s:color3, "", "")
  call <SID>X("scalaDef", s:color5, "", "")
  call <SID>X("scalaVal", s:color5, "", "")
  call <SID>X("scalaVar", s:color6, "", "")
  call <SID>X("scalaClass", s:color5, "", "")
  call <SID>X("scalaObject", s:color5, "", "")
  call <SID>X("scalaTrait", s:color5, "", "")
  call <SID>X("scalaDefName", s:color4, "", "")
  call <SID>X("scalaValName", s:foreground, "", "")
  call <SID>X("scalaVarName", s:foreground, "", "")
  call <SID>X("scalaClassName", s:foreground, "", "")
  call <SID>X("scalaType", s:color11, "", "")
  call <SID>X("scalaTypeSpecializer", s:color11, "", "")
  call <SID>X("scalaAnnotation", s:color3, "", "")
  call <SID>X("scalaNumber", s:color3, "", "")
  call <SID>X("scalaDefSpecializer", s:color11, "", "")
  call <SID>X("scalaClassSpecializer", s:color11, "", "")
  call <SID>X("scalaBackTick", s:color2, "", "")
  call <SID>X("scalaRoot", s:foreground, "", "")
  call <SID>X("scalaMethodCall", s:color4, "", "")
  call <SID>X("scalaCaseType", s:color11, "", "")
  call <SID>X("scalaLineComment", s:comment, "", "")
  call <SID>X("scalaComment", s:comment, "", "")
  call <SID>X("scalaDocComment", s:comment, "", "")
  call <SID>X("scalaDocTags", s:comment, "", "")
  call <SID>X("scalaEmptyString", s:color2, "", "")
  call <SID>X("scalaMultiLineString", s:color2, "", "")
  call <SID>X("scalaUnicode", s:color3, "", "")
  call <SID>X("scalaString", s:color2, "", "")
  call <SID>X("scalaStringEscape", s:color2, "", "")
  call <SID>X("scalaSymbol", s:color3, "", "")
  call <SID>X("scalaChar", s:color3, "", "")
  call <SID>X("scalaXml", s:color2, "", "")
  call <SID>X("scalaConstructorSpecializer", s:color11, "", "")
  call <SID>X("scalaBackTick", s:color4, "", "")

  " Git
  call <SID>X("diffAdded", s:color2, "", "")
  call <SID>X("diffRemoved", s:color1, "", "")
  call <SID>X("gitcommitSummary", "", "", "bold")

  " Delete Functions
  delf <SID>X
  delf <SID>rgb
  delf <SID>colour
  delf <SID>rgb_colour
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_colour
  delf <SID>grey_level
  delf <SID>grey_number
endif

set background=dark
