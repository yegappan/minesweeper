vim9script

import './constants.vim'

# Cell class represents a single cell in the Minesweeper grid

export class Cell
  public var isMine: bool = false
  public var isRevealed: bool = false
  public var isFlagged: bool = false
  public var neighborMines: number = 0
  public var row: number
  public var col: number

  def new(row: number, col: number)
    this.row = row
    this.col = col
  enddef

  # Helper function to get the right character based on GUI or terminal
  def GetSymbol(guiChar: string, terminalChar: string): string
    if has('gui_running')
      return guiChar
    else
      return terminalChar
    endif
  enddef

  # Reset cell to initial state
  def Reset()
    this.isMine = false
    this.isRevealed = false
    this.isFlagged = false
    this.neighborMines = 0
  enddef

  # Reveal the cell
  def Reveal(): bool
    if this.isFlagged || this.isRevealed
      return false
    endif
    
    this.isRevealed = true
    return true
  enddef

  # Toggle flag status
  def ToggleFlag(): bool
    if this.isRevealed
      return false
    endif
    
    this.isFlagged = !this.isFlagged
    return true
  enddef

  # Check if cell is safe to reveal
  def IsSafe(): bool
    return !this.isMine
  enddef

  # Get display character for the cell
  def GetDisplayChar(): string
    if !this.isRevealed
      if this.isFlagged
        return this.GetSymbol(constants.SYMBOLS_GUI.flag, constants.SYMBOLS_TERMINAL.flag)
      else
        return this.GetSymbol(constants.SYMBOLS_GUI.empty_cell, constants.SYMBOLS_TERMINAL.empty_cell)
      endif
    endif

    if this.isMine
      return this.GetSymbol(constants.SYMBOLS_GUI.mine, constants.SYMBOLS_TERMINAL.mine)
    endif

    if this.neighborMines == 0
      return this.GetSymbol(constants.SYMBOLS_GUI.empty_space, constants.SYMBOLS_TERMINAL.empty_space)
    endif

    # Use numbers for mine counts
    var guiNums = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
    var termNums = ['⓪', '①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧']
    var nums = has('gui_running') ? guiNums : termNums
    
    if this.neighborMines >= 0 && this.neighborMines < len(nums)
      return nums[this.neighborMines]
    endif

    return string(this.neighborMines)
  enddef
endclass

# Type alias for position
export type Position = dict<number>

# Create a position
export def MakePosition(row: number, col: number): Position
  return {row: row, col: col}
enddef

# Check if position is valid
export def IsValidPosition(pos: Position, rows: number, cols: number): bool
  return pos.row >= 0 && pos.row < rows && pos.col >= 0 && pos.col < cols
enddef
