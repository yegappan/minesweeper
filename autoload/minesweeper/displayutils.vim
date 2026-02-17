vim9script

import './constants.vim'

# Display and string utilities

# Get symbol based on GUI or terminal mode
export def GetSymbol(guiSymbol: string, terminalSymbol: string): string
  if has('gui_running')
    return guiSymbol
  else
    return terminalSymbol
  endif
enddef

# Get a symbol from the symbol table
export def GetSymbolFromTable(symbolName: string): string
  if has('gui_running')
    return constants.SYMBOLS_GUI->get(symbolName, '')
  else
    return constants.SYMBOLS_TERMINAL->get(symbolName, '')
  endif
enddef

# Get fixed cell width based on mode
export def GetCellWidth(): number
  return has('gui_running') ? constants.CELL_WIDTH_GUI : constants.CELL_WIDTH_TERMINAL
enddef

# Format a single cell with padding and centering
export def FormatCell(char: string, isCursor: bool): string
  var fixedCellWidth = GetCellWidth()
  
  var cellStr: string
  if isCursor
    cellStr = '[' .. char .. ']'
  else
    cellStr = ' ' .. char .. ' '
  endif
  
  # Pad to fixed width with symmetric padding (center the content)
  var displayWidth = strdisplaywidth(cellStr)
  var totalPadding = fixedCellWidth - displayWidth
  if totalPadding < 0
    totalPadding = 0
  endif
  
  # Split padding between left and right for centering
  var leftPadding = totalPadding / 2
  var rightPadding = totalPadding - leftPadding
  
  return repeat(' ', leftPadding) .. cellStr .. repeat(' ', rightPadding)
enddef

# Center text within a given width
export def CenterText(content: string, contentWidth: number): string
  var contentDisplayWidth = strdisplaywidth(content)
  var totalPadding = contentWidth - contentDisplayWidth
  var leftPadding = totalPadding / 2
  var rightPadding = totalPadding - leftPadding
  if leftPadding < 0
    leftPadding = 0
  endif
  if rightPadding < 0
    rightPadding = 0
  endif
  return repeat(' ', leftPadding) .. content .. repeat(' ', rightPadding)
enddef

# Pad a line with exact width
export def PadLine(content: string, targetWidth: number): string
  var padding = targetWidth - strdisplaywidth(content)
  if padding < 0
    padding = 0
  endif
  return content .. repeat(' ', padding)
enddef

# Create a horizontal border line
export def MakeBorder(contentWidth: number, left: string, mid: string, right: string): string
  var midWidth = strdisplaywidth(mid)
  var repeatCount = contentWidth / midWidth
  if repeatCount < 1
    repeatCount = 1
  endif
  return left .. repeat(mid, repeatCount) .. right
enddef
