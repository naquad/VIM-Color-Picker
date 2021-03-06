"Script: VIM Color Picker
"Version: 0.1
"Copyright: Copyright (C) 2010  Fabien Loison
"Copyright: Copyright (C) 2014  Naquad <naquad@gmail.com>
"Licence: GPLv3+ (see the "COPYING" file for more information)
"Website: http://www.flogisoft.com/
"
"DEPENDENCIES:
"  For working, this script need:
"    * VIM 7.x with Python support
"    * Python3 along with Gtk3 introspection bindings 
"
"INSTALL:
"  Copy "color_picker.vim" and "color.py" in your pluggin directory,
"  don't forget to make "color.py" executable.
"
"USAGE:
"  Whenever your cursor is over the color you can :ColorPicker
"  and it'll start color dialog. After you accept new color
"  it'll replace old color. If there was no color under your cursor
"  it'll be simply inserted.
"
"  Supported color formats: all from http://www.w3.org/TR/css3-color/

" Color list from http://www.w3.org/TR/css3-color/
let s:CSSColors = {
      \ 'aliceblue'            : '#F0F8FF',
      \ 'antiquewhite'         : '#FAEBD7',
      \ 'aqua'                 : '#00FFFF',
      \ 'aquamarine'           : '#7FFFD4',
      \ 'azure'                : '#F0FFFF',
      \ 'beige'                : '#F5F5DC',
      \ 'bisque'               : '#FFE4C4',
      \ 'black'                : '#000000',
      \ 'blanchedalmond'       : '#FFEBCD',
      \ 'blue'                 : '#0000FF',
      \ 'blueviolet'           : '#8A2BE2',
      \ 'brown'                : '#A52A2A',
      \ 'burlywood'            : '#DEB887',
      \ 'cadetblue'            : '#5F9EA0',
      \ 'chartreuse'           : '#7FFF00',
      \ 'chocolate'            : '#D2691E',
      \ 'coral'                : '#FF7F50',
      \ 'cornflowerblue'       : '#6495ED',
      \ 'cornsilk'             : '#FFF8DC',
      \ 'crimson'              : '#DC143C',
      \ 'cyan'                 : '#00FFFF',
      \ 'darkblue'             : '#00008B',
      \ 'darkcyan'             : '#008B8B',
      \ 'darkgoldenrod'        : '#B8860B',
      \ 'darkgray'             : '#A9A9A9',
      \ 'darkgreen'            : '#006400',
      \ 'darkgrey'             : '#A9A9A9',
      \ 'darkkhaki'            : '#BDB76B',
      \ 'darkmagenta'          : '#8B008B',
      \ 'darkolivegreen'       : '#556B2F',
      \ 'darkorange'           : '#FF8C00',
      \ 'darkorchid'           : '#9932CC',
      \ 'darkred'              : '#8B0000',
      \ 'darksalmon'           : '#E9967A',
      \ 'darkseagreen'         : '#8FBC8F',
      \ 'darkslateblue'        : '#483D8B',
      \ 'darkslategray'        : '#2F4F4F',
      \ 'darkslategrey'        : '#2F4F4F',
      \ 'darkturquoise'        : '#00CED1',
      \ 'darkviolet'           : '#9400D3',
      \ 'deeppink'             : '#FF1493',
      \ 'deepskyblue'          : '#00BFFF',
      \ 'dimgray'              : '#696969',
      \ 'dimgrey'              : '#696969',
      \ 'dodgerblue'           : '#1E90FF',
      \ 'firebrick'            : '#B22222',
      \ 'floralwhite'          : '#FFFAF0',
      \ 'forestgreen'          : '#228B22',
      \ 'fuchsia'              : '#FF00FF',
      \ 'gainsboro'            : '#DCDCDC',
      \ 'ghostwhite'           : '#F8F8FF',
      \ 'gold'                 : '#FFD700',
      \ 'goldenrod'            : '#DAA520',
      \ 'gray'                 : '#808080',
      \ 'green'                : '#008000',
      \ 'greenyellow'          : '#ADFF2F',
      \ 'grey'                 : '#808080',
      \ 'honeydew'             : '#F0FFF0',
      \ 'hotpink'              : '#FF69B4',
      \ 'indianred'            : '#CD5C5C',
      \ 'indigo'               : '#4B0082',
      \ 'ivory'                : '#FFFFF0',
      \ 'khaki'                : '#F0E68C',
      \ 'lavender'             : '#E6E6FA',
      \ 'lavenderblush'        : '#FFF0F5',
      \ 'lawngreen'            : '#7CFC00',
      \ 'lemonchiffon'         : '#FFFACD',
      \ 'lightblue'            : '#ADD8E6',
      \ 'lightcoral'           : '#F08080',
      \ 'lightcyan'            : '#E0FFFF',
      \ 'lightgoldenrodyellow' : '#FAFAD2',
      \ 'lightgray'            : '#D3D3D3',
      \ 'lightgreen'           : '#90EE90',
      \ 'lightgrey'            : '#D3D3D3',
      \ 'lightpink'            : '#FFB6C1',
      \ 'lightsalmon'          : '#FFA07A',
      \ 'lightseagreen'        : '#20B2AA',
      \ 'lightskyblue'         : '#87CEFA',
      \ 'lightslategray'       : '#778899',
      \ 'lightslategrey'       : '#778899',
      \ 'lightsteelblue'       : '#B0C4DE',
      \ 'lightyellow'          : '#FFFFE0',
      \ 'lime'                 : '#00FF00',
      \ 'limegreen'            : '#32CD32',
      \ 'linen'                : '#FAF0E6',
      \ 'magenta'              : '#FF00FF',
      \ 'maroon'               : '#800000',
      \ 'mediumaquamarine'     : '#66CDAA',
      \ 'mediumblue'           : '#0000CD',
      \ 'mediumorchid'         : '#BA55D3',
      \ 'mediumpurple'         : '#9370DB',
      \ 'mediumseagreen'       : '#3CB371',
      \ 'mediumslateblue'      : '#7B68EE',
      \ 'mediumspringgreen'    : '#00FA9A',
      \ 'mediumturquoise'      : '#48D1CC',
      \ 'mediumvioletred'      : '#C71585',
      \ 'midnightblue'         : '#191970',
      \ 'mintcream'            : '#F5FFFA',
      \ 'mistyrose'            : '#FFE4E1',
      \ 'moccasin'             : '#FFE4B5',
      \ 'navajowhite'          : '#FFDEAD',
      \ 'navy'                 : '#000080',
      \ 'oldlace'              : '#FDF5E6',
      \ 'olive'                : '#808000',
      \ 'olivedrab'            : '#6B8E23',
      \ 'orange'               : '#FFA500',
      \ 'orangered'            : '#FF4500',
      \ 'orchid'               : '#DA70D6',
      \ 'palegoldenrod'        : '#EEE8AA',
      \ 'palegreen'            : '#98FB98',
      \ 'paleturquoise'        : '#AFEEEE',
      \ 'palevioletred'        : '#DB7093',
      \ 'papayawhip'           : '#FFEFD5',
      \ 'peachpuff'            : '#FFDAB9',
      \ 'peru'                 : '#CD853F',
      \ 'pink'                 : '#FFC0CB',
      \ 'plum'                 : '#DDA0DD',
      \ 'powderblue'           : '#B0E0E6',
      \ 'purple'               : '#800080',
      \ 'red'                  : '#FF0000',
      \ 'rosybrown'            : '#BC8F8F',
      \ 'royalblue'            : '#4169E1',
      \ 'saddlebrown'          : '#8B4513',
      \ 'salmon'               : '#FA8072',
      \ 'sandybrown'           : '#F4A460',
      \ 'seagreen'             : '#2E8B57',
      \ 'seashell'             : '#FFF5EE',
      \ 'sienna'               : '#A0522D',
      \ 'silver'               : '#C0C0C0',
      \ 'skyblue'              : '#87CEEB',
      \ 'slateblue'            : '#6A5ACD',
      \ 'slategray'            : '#708090',
      \ 'slategrey'            : '#708090',
      \ 'snow'                 : '#FFFAFA',
      \ 'springgreen'          : '#00FF7F',
      \ 'steelblue'            : '#4682B4',
      \ 'tan'                  : '#D2B48C',
      \ 'teal'                 : '#008080',
      \ 'thistle'              : '#D8BFD8',
      \ 'tomato'               : '#FF6347',
      \ 'turquoise'            : '#40E0D0',
      \ 'violet'               : '#EE82EE',
      \ 'wheat'                : '#F5DEB3',
      \ 'white'                : '#FFFFFF',
      \ 'whitesmoke'           : '#F5F5F5',
      \ 'yellow'               : '#FFFF00',
      \ 'yellowgreen'          : '#9ACD32',
      \ }

" Insane regexp construction
let s:HEXRe = '#\%\(\x\{6}\|\x\{3}\)'
let s:RGBColorRe = '\%\(-\?\d\+%\?\|0x\x\+\)'
let s:RGBAOpacity = '\%\(\d\+\%\(\.\d\+\)\?\)'
let s:RGBVals = repeat([s:RGBColorRe], 3)
let s:RGBRe = 'rgb\s*(\s*' . join(s:RGBVals, '\s*,\s*') . '\s*)'
call add(s:RGBVals, s:RGBAOpacity)
let s:RGBARe = 'rgba\s*(\s*' . join(s:RGBVals, '\s*,\s*') . '\s*)'

let s:ColorPattern = '\(' . join([s:HEXRe, s:RGBRe, s:RGBARe], '\|') .  '\)\|\(\w\+\)'

" Where's color picker dialog
let s:ColorPy = shellescape(expand('<sfile>:p:h') . '/color.py')

" Matches regexp *around* cursor position.
" Ugly implementation, but I didn't find any other way.

function! s:MatchAroundList(line, pos, pattern)
  let omatch = 0

  while 1
    let nmatch = match(a:line, a:pattern, omatch)
    if nmatch < omatch
      return {}
    endif

    let len = strlen(matchstr(a:line, a:pattern, nmatch))
    if nmatch <= a:pos && nmatch + len >= a:pos
      return {
            \ 'match': matchlist(a:line, a:pattern, nmatch),
            \ 'starts': nmatch,
            \ 'ends': nmatch + len
            \ }
    endif

    let omatch = nmatch + 1
  endwhile
endfunction

" Runs script and returns new color or empty string
" if dialog canceled/failed to start
" TODO: maybe add some error reporting?
function! s:ExecuteScript(color)
  let cmdline = s:ColorPy
  if a:color != ''
    let cmdline .= ' ' . shellescape(a:color)
  endif

  let output = systemlist(cmdline)

  if v:shell_error
    return ''
  endif

  return substitute(output[-1], '\r\?\n', '', '')
endfunction

" Replaces text at given start/end positions in current line
function! s:SetAt(start, end, text)
  let line = getline('.')
  let left = a:start > 0 ? line[: a:start - 1] : ''
  call setline(line('.'), left . a:text . line[a:end :])
endfunction

" Figures out color under the cursor
function! s:ColorAtCursor()
  let ccolor = s:MatchAroundList(getline('.'), col('.'), s:ColorPattern)
  let ccolor.color = ''

  if !has_key(ccolor, 'match')
    return ccolor
  endif

  if ccolor.match[1] != ''
    let ccolor.color = ccolor.match[1]
  elseif ccolor.match[2] != ''
    let cname = tolower(ccolor.match[2])

    if has_key(s:CSSColors, cname)
      let ccolor.color = s:CSSColors[cname]
    endif
  endif

  return ccolor
endfunction

function! s:ColorPicker()
  let ccolor = s:ColorAtCursor()
  let ncolor = s:ExecuteScript(ccolor.color)

  if ncolor == ''
    return
  endif

  if empty(ccolor.color)
    let ccol = col('.') - 1
    call s:SetAt(ccol, ccol, ncolor)
  else
    call s:SetAt(ccolor.starts, ccolor.ends, ncolor)
  endif
endfunction

command! ColorPicker call <SID>ColorPicker()
