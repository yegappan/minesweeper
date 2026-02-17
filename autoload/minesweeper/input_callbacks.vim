vim9script

# Input callback functions
# These functions are called by the key mappings

# Get the current input handler
def GetInputHandler(): any
  return minesweeper#GetInput()
enddef

# Movement callbacks
export def MoveLeft()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleMove(0, -1)
  endif
enddef

export def MoveRight()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleMove(0, 1)
  endif
enddef

export def MoveUp()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleMove(-1, 0)
  endif
enddef

export def MoveDown()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleMove(1, 0)
  endif
enddef

# Action callbacks
export def Reveal()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleReveal()
  endif
enddef

export def ToggleFlag()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleToggleFlag()
  endif
enddef

export def Restart()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleRestart()
  endif
enddef

export def Quit()
  var handler = GetInputHandler()
  if handler != null_object
    handler.HandleQuit()
  endif
enddef
