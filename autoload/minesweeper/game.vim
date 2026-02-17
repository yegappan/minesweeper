vim9script

import './board.vim' as BoardModule
import './cell.vim'
import './constants.vim'

# Game class - main game controller
export class Game
  public var board: BoardModule.Board
  public var state: BoardModule.GameState
  public var firstMove: bool = true
  public var startTime: number = 0
  public var endTime: number = 0
  public var cursorRow: number = 0
  public var cursorCol: number = 0
  public var bufnr: number = -1
  public var difficulty: BoardModule.Difficulty

  def new(difficulty: BoardModule.Difficulty = BoardModule.Difficulty.EASY)
    this.difficulty = difficulty
    this.board = BoardModule.CreateBoardFromDifficulty(difficulty)
    this.state = BoardModule.GameState.PLAYING
    this.cursorRow = this.board.height / 2
    this.cursorCol = this.board.width / 2
  enddef

  # Start a new game
  def Start()
    this.board.Reset()
    this.state = BoardModule.GameState.PLAYING
    this.firstMove = true
    this.startTime = localtime()
    this.endTime = 0
    this.cursorRow = this.board.height / 2
    this.cursorCol = this.board.width / 2
  enddef

  # Handle cell reveal
  def HandleReveal(row: number, col: number): bool
    if this.state != BoardModule.GameState.PLAYING
      return false
    endif

    # Place mines on first move (avoid first clicked cell)
    if this.firstMove
      this.board.PlaceMines(row, col)
      this.firstMove = false
    endif

    var hitMine = this.board.RevealCell(row, col)
    
    if hitMine
      this.state = BoardModule.GameState.LOST
      this.endTime = localtime()
      this.board.RevealAllMines()
      return false
    endif

    # Check for win
    if this.board.IsWon()
      this.state = BoardModule.GameState.WON
      this.endTime = localtime()
    endif

    return true
  enddef

  # Handle flag toggle
  def HandleFlag(row: number, col: number)
    if this.state != BoardModule.GameState.PLAYING
      return
    endif

    this.board.ToggleFlag(row, col)
  enddef

  # Move cursor
  def MoveCursor(drow: number, dcol: number)
    this.cursorRow = max([0, min([this.board.height - 1, this.cursorRow + drow])])
    this.cursorCol = max([0, min([this.board.width - 1, this.cursorCol + dcol])])
  enddef

  # Get elapsed time
  def GetElapsedTime(): number
    if this.startTime == 0
      return 0
    endif
    
    var endT = this.endTime > 0 ? this.endTime : localtime()
    return endT - this.startTime
  enddef

  # Get remaining mines count
  def GetRemainingMines(): number
    return this.board.mineCount - this.board.flagCount
  enddef

  # Check if game is over
  def IsGameOver(): bool
    return this.state == BoardModule.GameState.WON || this.state == BoardModule.GameState.LOST
  enddef

  # Get game status message
  def GetStatusMessage(): string
    var winSymbol = has('gui_running') ? constants.SYMBOLS_GUI.win : constants.SYMBOLS_TERMINAL.win
    var loseSymbol = has('gui_running') ? constants.SYMBOLS_GUI.lose : constants.SYMBOLS_TERMINAL.lose
    
    if this.state == BoardModule.GameState.WON
      return 'YOU WON! ' .. winSymbol
    elseif this.state == BoardModule.GameState.LOST
      return 'GAME OVER ' .. loseSymbol
    else
      return 'Playing...'
    endif
  enddef

  # Restart game with same difficulty
  def Restart()
    this.board = BoardModule.CreateBoardFromDifficulty(this.difficulty)
    this.Start()
  enddef
endclass
