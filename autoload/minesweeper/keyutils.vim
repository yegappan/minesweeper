vim9script

# Key detection and handling utilities

# Check if a key is a movement key
export def IsMovementKey(key: string): dict<any>
  var result = {isMovement: false, drow: 0, dcol: 0}
  
  # Vim key bindings
  if key == 'h' || key == 'H'
    result.isMovement = true
    result.dcol = -1
  elseif key == 'j' || key == 'J'
    result.isMovement = true
    result.drow = 1
  elseif key == 'k' || key == 'K'
    result.isMovement = true
    result.drow = -1
  elseif key == 'l' || key == 'L'
    result.isMovement = true
    result.dcol = 1
  # Arrow keys - Vim special keys
  elseif key == "\<Up>" || key == "\<kUp>"
    result.isMovement = true
    result.drow = -1
  elseif key == "\<Down>" || key == "\<kDown>"
    result.isMovement = true
    result.drow = 1
  elseif key == "\<Right>" || key == "\<kRight>"
    result.isMovement = true
    result.dcol = 1
  elseif key == "\<Left>" || key == "\<kLeft>"
    result.isMovement = true
    result.dcol = -1
  # Terminal escape sequences
  elseif len(key) >= 3 && key[0] == "\x1b"
    var code = key[2]
    if code == 'A'  # Up
      result.isMovement = true
      result.drow = -1
    elseif code == 'B'  # Down
      result.isMovement = true
      result.drow = 1
    elseif code == 'C'  # Right
      result.isMovement = true
      result.dcol = 1
    elseif code == 'D'  # Left
      result.isMovement = true
      result.dcol = -1
    endif
  # Vim internal arrow key codes (gvim, Windows)
  elseif key =~ "\<80>k[udlr]"
    if key =~ "ku"  # Up
      result.isMovement = true
      result.drow = -1
    elseif key =~ "kd"  # Down
      result.isMovement = true
      result.drow = 1
    elseif key =~ "kl"  # Left
      result.isMovement = true
      result.dcol = -1
    elseif key =~ "kr"  # Right
      result.isMovement = true
      result.dcol = 1
    endif
  endif
  
  return result
enddef

# Check if a key is an action key
export def GetActionType(key: string): string
  if key == ' ' || key == "\r"
    return 'reveal'
  elseif key == 'f' || key == 'F'
    return 'flag'
  elseif key == 'r' || key == 'R'
    return 'restart'
  elseif key == 'q' || key == 'Q' || key == "\x1b"
    return 'quit'
  endif
  
  return ''
enddef
