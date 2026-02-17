vim9script

import './game.vim' as GameModule
import './renderer.vim' as RendererModule
import './keyutils.vim'

# InputHandler class manages user input
export class InputHandler
  public var game: GameModule.Game
  public var renderer: RendererModule.Renderer
  public var active: bool = false

  def new(game: GameModule.Game, renderer: RendererModule.Renderer)
    this.game = game
    this.renderer = renderer
  enddef

  # Setup key mappings
  def SetupMappings()
    # Don't check winid here - it hasn't been created yet
    # Just register the filter function, it will be used when window opens
    this.renderer.SetFilterFunc((winid, key) => this.PopupFilter(winid, key))
    this.active = true
  enddef

  # Popup filter function that handles all keys
  def PopupFilter(winid: number, key: string): bool
    # Safety check - ensure key is not empty
    if len(key) == 0
      return 1
    endif
    
    # Check for movement keys
    var movementResult = keyutils.IsMovementKey(key)
    if movementResult.isMovement
      this.HandleMove(movementResult.drow, movementResult.dcol)
      return 1
    endif
    
    # Check for action keys
    var actionType = keyutils.GetActionType(key)
    if actionType == 'reveal'
      this.HandleReveal()
      return 1
    elseif actionType == 'flag'
      this.HandleToggleFlag()
      return 1
    elseif actionType == 'restart'
      this.HandleRestart()
      return 1
    elseif actionType == 'quit'
      this.HandleQuit()
      return 1
    endif
    
    # Consume all other keys to prevent popup from closing
    return 1
  enddef

  # Handle movement
  def HandleMove(drow: number, dcol: number)
    this.game.MoveCursor(drow, dcol)
    this.renderer.Render()
  enddef

  # Handle reveal
  def HandleReveal()
    this.game.HandleReveal(this.game.cursorRow, this.game.cursorCol)
    this.renderer.Render()
  enddef

  # Handle flag toggle
  def HandleToggleFlag()
    this.game.HandleFlag(this.game.cursorRow, this.game.cursorCol)
    this.renderer.Render()
  enddef

  # Handle restart
  def HandleRestart()
    this.game.Restart()
    this.renderer.Render()
  enddef

  # Handle quit
  def HandleQuit()
    this.active = false
    this.renderer.Close()
  enddef
endclass
