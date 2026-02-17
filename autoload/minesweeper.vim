vim9script

import './minesweeper/game.vim' as GameModule
import './minesweeper/renderer.vim' as RendererModule
import './minesweeper/input.vim' as InputModule
import './minesweeper/board.vim' as BoardModule

# Global game instance
var currentGame: GameModule.Game = null_object
var currentRenderer: RendererModule.Renderer = null_object
var currentInput: InputModule.InputHandler = null_object

# Start game with custom settings
export def Start()
  var width = get(g:, 'minesweeper_width', 10)
  var height = get(g:, 'minesweeper_height', 10)
  var mines = get(g:, 'minesweeper_mines', 10)
  
  StartGame(BoardModule.Difficulty.CUSTOM, width, height, mines)
enddef

# Start game with difficulty level
export def StartDifficulty(level: string)
  var difficulty: BoardModule.Difficulty
  
  if level ==? 'easy'
    difficulty = BoardModule.Difficulty.EASY
  elseif level ==? 'medium'
    difficulty = BoardModule.Difficulty.MEDIUM
  elseif level ==? 'hard'
    difficulty = BoardModule.Difficulty.HARD
  else
    difficulty = BoardModule.Difficulty.EASY
  endif
  
  StartGame(difficulty, 0, 0, 0)
enddef

# Internal function to start game
def StartGame(difficulty: BoardModule.Difficulty, width: number = 0, height: number = 0, mines: number = 0)
  # Clean up existing game if any
  if currentInput != null_object && currentInput.active
    currentInput.HandleQuit()
  endif

  # Create new game
  if difficulty == BoardModule.Difficulty.CUSTOM && width > 0 && height > 0
    currentGame = GameModule.Game.new(difficulty)
    currentGame.board = BoardModule.Board.new(width, height, mines)
  else
    currentGame = GameModule.Game.new(difficulty)
  endif
  
  currentGame.Start()
  
  # Create renderer
  currentRenderer = RendererModule.Renderer.new(currentGame)
  
  # Create input handler and setup before opening window
  currentInput = InputModule.InputHandler.new(currentGame, currentRenderer)
  currentInput.SetupMappings()
  
  # Now open the window with filter already installed
  currentRenderer.OpenWindow()
enddef

# Get current game instance (for debugging)
export def GetGame(): GameModule.Game
  return currentGame
enddef

# Get current input handler (for debugging)
export def GetInput(): InputModule.InputHandler
  return currentInput
enddef
