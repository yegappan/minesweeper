vim9script

import './cell.vim' as CellModule

# GameState enum using const
export enum GameState
  PLAYING,
  WON,
  LOST
endenum

# Difficulty levels
export enum Difficulty
  EASY,
  MEDIUM,
  HARD,
  CUSTOM
endenum

# Board class manages the game grid
export class Board
  public var width: number
  public var height: number
  public var mineCount: number
  public var cells: list<list<CellModule.Cell>>
  public var revealedCount: number = 0
  public var flagCount: number = 0
  
  # Direction offsets for neighbors
  const directions: list<list<number>> = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1],           [0, 1],
    [1, -1],  [1, 0],  [1, 1]
  ]

  def new(width: number, height: number, mineCount: number)
    this.width = width
    this.height = height
    this.mineCount = mineCount
    this.cells = []
    this.InitializeCells()
  enddef

  # Initialize the grid with cells
  def InitializeCells()
    this.cells = []
    for row in range(this.height)
      var rowCells: list<CellModule.Cell> = []
      for col in range(this.width)
        add(rowCells, CellModule.Cell.new(row, col))
      endfor
      add(this.cells, rowCells)
    endfor
  enddef

  # Place mines randomly on the board
  def PlaceMines(excludeRow: number = -1, excludeCol: number = -1)
    var minesPlaced = 0
    var totalCells = this.width * this.height
    
    if this.mineCount >= totalCells
      this.mineCount = totalCells - 1
    endif

    while minesPlaced < this.mineCount
      var row = rand() % this.height
      var col = rand() % this.width
      
      # Don't place mine on first clicked cell or on existing mine
      if (row == excludeRow && col == excludeCol) || this.cells[row][col].isMine
        continue
      endif
      
      this.cells[row][col].isMine = true
      minesPlaced += 1
    endwhile

    this.CalculateNeighborMines()
  enddef

  # Calculate neighbor mine counts for all cells
  def CalculateNeighborMines()
    for row in range(this.height)
      for col in range(this.width)
        if !this.cells[row][col].isMine
          this.cells[row][col].neighborMines = this.CountNeighborMines(row, col)
        endif
      endfor
    endfor
  enddef

  # Count mines in neighboring cells
  def CountNeighborMines(row: number, col: number): number
    var count = 0
    
    for dir in this.directions
      var newRow = row + dir[0]
      var newCol = col + dir[1]
      
      if this.IsValidCell(newRow, newCol)
        if this.cells[newRow][newCol].isMine
          count += 1
        endif
      endif
    endfor
    
    return count
  enddef

  # Check if cell coordinates are valid
  def IsValidCell(row: number, col: number): bool
    return row >= 0 && row < this.height && col >= 0 && col < this.width
  enddef

  # Reveal a cell (returns true if mine hit)
  def RevealCell(row: number, col: number): bool
    if !this.IsValidCell(row, col)
      return false
    endif

    var cell = this.cells[row][col]
    
    if !cell.Reveal()
      return false
    endif

    this.revealedCount += 1

    # If mine, game over
    if cell.isMine
      return true
    endif

    # If no neighbor mines, use BFS to reveal connected empty cells
    if cell.neighborMines == 0
      this.RevealConnectedCells(row, col)
    endif

    return false
  enddef

  # Iteratively reveal connected cells with 0 neighbors (BFS approach)
  def RevealConnectedCells(startRow: number, startCol: number)
    # Create a queue of cells to process
    var queue: list<list<number>> = [[startRow, startCol]]
    var processed: dict<bool> = {}
    var key = startRow .. ',' .. startCol
    processed[key] = true
    
    while len(queue) > 0
      var current = remove(queue, 0)
      var row = current[0]
      var col = current[1]
      
      # Check all neighbors
      for dir in this.directions
        var newRow = row + dir[0]
        var newCol = col + dir[1]
        var newKey = newRow .. ',' .. newCol
        
        if this.IsValidCell(newRow, newCol) && !processed->get(newKey, false)
          processed[newKey] = true
          var neighbor = this.cells[newRow][newCol]
          
          # Only process unrevealed, unflagged cells
          if !neighbor.isRevealed && !neighbor.isFlagged
            if neighbor.Reveal()
              this.revealedCount += 1
              
              # If this neighbor also has 0 mines, add it to queue
              if neighbor.neighborMines == 0
                add(queue, [newRow, newCol])
              endif
            endif
          endif
        endif
      endfor
    endwhile
  enddef

  # Toggle flag on a cell
  def ToggleFlag(row: number, col: number): bool
    if !this.IsValidCell(row, col)
      return false
    endif

    var cell = this.cells[row][col]
    var wasFlagged = cell.isFlagged
    
    if cell.ToggleFlag()
      if cell.isFlagged
        this.flagCount += 1
      else
        this.flagCount -= 1
      endif
      return true
    endif

    return false
  enddef

  # Check if player has won
  def IsWon(): bool
    if this.revealedCount != (this.width * this.height - this.mineCount)
      return false
    endif

    if this.flagCount != this.mineCount
      return false
    endif

    for row in range(this.height)
      for col in range(this.width)
        var cell = this.cells[row][col]
        if cell.isMine && !cell.isFlagged
          return false
        endif
        if !cell.isMine && !cell.isRevealed
          return false
        endif
      endfor
    endfor

    return true
  enddef

  # Reveal all mines (for game over)
  def RevealAllMines()
    for row in range(this.height)
      for col in range(this.width)
        if this.cells[row][col].isMine
          this.cells[row][col].isRevealed = true
        endif
      endfor
    endfor
  enddef

  # Get cell at position
  def GetCell(row: number, col: number): CellModule.Cell
    if this.IsValidCell(row, col)
      return this.cells[row][col]
    endif
    return null_object
  enddef

  # Reset the board
  def Reset()
    this.revealedCount = 0
    this.flagCount = 0
    this.InitializeCells()
  enddef
endclass

# Factory function for difficulty levels
export def CreateBoardFromDifficulty(difficulty: Difficulty): Board
  if difficulty == Difficulty.EASY
    return Board.new(8, 8, 10)
  elseif difficulty == Difficulty.MEDIUM
    return Board.new(16, 16, 40)
  elseif difficulty == Difficulty.HARD
    return Board.new(30, 16, 99)
  else
    return Board.new(10, 10, 10)
  endif
enddef
