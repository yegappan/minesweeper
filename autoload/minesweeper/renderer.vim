vim9script

import './game.vim' as GameModule
import './board.vim' as BoardModule
import './cell.vim' as CellModule
import './constants.vim'
import './displayutils.vim'

export class Renderer
  public var game: GameModule.Game
  public var bufnr: number = -1
  public var winid: number = -1
  public var FilterFunc: func = null_function
  public var timer_id: number = -1

  def new(game: GameModule.Game)
    this.game = game
  enddef

  # Set the input filter function
  def SetFilterFunc(FilterFunc: func)
    this.FilterFunc = FilterFunc
  enddef
  
  # Get the right character based on GUI or terminal mode
  def GetSymbol(guiChar: string, terminalChar: string): string
    return displayutils.GetSymbol(guiChar, terminalChar)
  enddef
  
  # Get fixed cell width based on mode
  def GetFixedCellWidth(): number
    return displayutils.GetCellWidth()
  enddef
  
  # Format a single cell with correct padding and centering
  def FormatCell(char: string, isCursor: bool): string
    return displayutils.FormatCell(char, isCursor)
  enddef
  
  # Create a horizontal border
  def MakeBorder(contentWidth: number, left: string, mid: string, right: string): string
    return displayutils.MakeBorder(contentWidth, left, mid, right)
  enddef
  
  # Pad a content line with side borders
  def MakeLine(content: string, contentWidth: number): string
    var padding = contentWidth - strdisplaywidth(content)
    if padding < 0
      padding = 0
    endif
    return constants.BORDER_CHARS.vertical .. content .. repeat(' ', padding) .. constants.BORDER_CHARS.vertical
  enddef
  
  # Center text within available width
  def CenterText(content: string, contentWidth: number): string
    return displayutils.CenterText(content, contentWidth)
  enddef
  
  # Generate the header section (title and game info)
  def GenerateHeader(contentWidth: number): list<string>
    var headerLines: list<string> = []
    
    var titleDecor = this.GetSymbol(constants.SYMBOLS_GUI.title_decor, constants.SYMBOLS_TERMINAL.title_decor)
    add(headerLines, this.CenterText(' ' .. titleDecor .. ' MINESWEEPER ' .. titleDecor .. ' ', contentWidth))
    
    var mines = printf('Mines: %d', this.game.GetRemainingMines())
    var time = printf('Time: %ds', this.game.GetElapsedTime())
    var infoLine = ' ' .. mines .. '   ' .. time .. ' '
    add(headerLines, this.CenterText(infoLine, contentWidth))
    
    var status = this.game.GetStatusMessage()
    add(headerLines, this.CenterText(' Status: ' .. status .. ' ', contentWidth))
    
    return headerLines
  enddef
  
  # Generate the board section
  def GenerateBoard(contentWidth: number): list<string>
    var boardLines: list<string> = []
    
    add(boardLines, this.MakeBorder(contentWidth, constants.BORDER_CHARS.top_left, constants.BORDER_CHARS.horizontal, constants.BORDER_CHARS.top_right))
    
    for row in range(this.game.board.height)
      var cellContent = ''
      for col in range(this.game.board.width)
        var cell = this.game.board.GetCell(row, col)
        var char = cell.GetDisplayChar()
        var isCursor = (row == this.game.cursorRow && col == this.game.cursorCol)
        cellContent ..= this.FormatCell(char, isCursor)
      endfor
      add(boardLines, this.MakeLine(cellContent, contentWidth))
    endfor
    
    add(boardLines, this.MakeBorder(contentWidth, constants.BORDER_CHARS.bottom_left, constants.BORDER_CHARS.horizontal, constants.BORDER_CHARS.bottom_right))
    
    return boardLines
  enddef
  
  # Generate footer with instructions
  def GenerateFooter(): list<string>
    var footerLines: list<string> = []
    add(footerLines, constants.FULL_INSTRUCTIONS_1)
    add(footerLines, constants.FULL_INSTRUCTIONS_2)
    return footerLines
  enddef

  # Create game buffer and window
  def OpenWindow()
    # Fixed cell width for alignment
    var fixedCellWidth = this.GetFixedCellWidth()
    
    # Calculate total board width
    var estimatedContentWidth = this.game.board.width * fixedCellWidth
    var instrWidth = strdisplaywidth(constants.FULL_INSTRUCTIONS_1)
    var width = max([estimatedContentWidth + 2, instrWidth])
    var height = this.game.board.height + 10

    # Check if popup fits in the current Vim window
    var vimWidth = &columns
    var vimHeight = &lines
    
    if width > vimWidth || height > vimHeight
      echohl ErrorMsg
      echo printf('Window too small! Need at least %dx%d, but Vim window is %dx%d', width, height, vimWidth, vimHeight)
      echohl None
      return
    endif

    # Setup highlights before creating popup
    this.SetupHighlights()

    # Render initial content
    var lines = this.GenerateLines()

    # Create popup options
    # Since we're drawing borders manually in content, don't use popup borders
    var opts = {
      line: 'cursor',
      col: 'cursor',
      pos: 'center',
      minwidth: width,
      maxwidth: width,
      minheight: height,
      maxheight: height,
      border: [],
      padding: [0, 0, 0, 0],
      close: 'button',
      mapping: 0,
      callback: (winid, result) => {
        # Cleanup when popup closes
        if this.bufnr > 0
          silent! execute 'bwipeout! ' .. this.bufnr
        endif
      }
    }

    # Add filter function if set
    if this.FilterFunc != null_function
      opts.filter = this.FilterFunc
    else
      opts.filter = (winid, key) => 1
    endif

    # Create popup window
    this.winid = popup_create(lines, opts)
    this.bufnr = winbufnr(this.winid)

    # Set buffer options
    setbufvar(this.bufnr, '&buftype', 'nofile')
    setbufvar(this.bufnr, '&bufhidden', 'wipe')
    setbufvar(this.bufnr, '&swapfile', 0)
    setbufvar(this.bufnr, '&buflisted', 0)
    setbufvar(this.bufnr, '&filetype', 'minesweeper')

    # Start timer to continuously update display
    this.timer_id = timer_start(500, this.TimerCallback)
  enddef

  # Timer callback to update display continuously
  def TimerCallback(timer_id: number)
    this.Render()
  enddef

  # Setup syntax highlighting
  def SetupHighlights()
    if hlexists('MinesweeperCell')
      return
    endif

    execute 'highlight MinesweeperCell ctermfg=White ctermbg=DarkGray guifg=#FFFFFF guibg=#3C3C3C'
    execute 'highlight MinesweeperRevealed ctermfg=Black ctermbg=Gray guifg=#000000 guibg=#A8A8A8'
    execute 'highlight MinesweeperMine ctermfg=Red ctermbg=Black guifg=#FF0000 guibg=#000000 gui=bold'
    execute 'highlight MinesweeperFlag ctermfg=Yellow ctermbg=DarkGray guifg=#FFFF00 guibg=#3C3C3C gui=bold'
    execute 'highlight MinesweeperCursor ctermfg=White ctermbg=Blue guifg=#FFFFFF guibg=#0000FF gui=bold'
    execute 'highlight MinesweeperNumber1 ctermfg=Blue guifg=#0000FF gui=bold'
    execute 'highlight MinesweeperNumber2 ctermfg=Green guifg=#00FF00 gui=bold'
    execute 'highlight MinesweeperNumber3 ctermfg=Red guifg=#FF0000 gui=bold'
    execute 'highlight MinesweeperNumber4 ctermfg=DarkBlue guifg=#000080 gui=bold'
    execute 'highlight MinesweeperNumber5 ctermfg=DarkRed guifg=#800000 gui=bold'
    execute 'highlight MinesweeperNumber6 ctermfg=Cyan guifg=#00FFFF gui=bold'
    execute 'highlight MinesweeperNumber7 ctermfg=Black guifg=#000000 gui=bold'
    execute 'highlight MinesweeperNumber8 ctermfg=Gray guifg=#808080 gui=bold'
    execute 'highlight MinesweeperHeader ctermfg=Cyan guifg=#00FFFF gui=bold'
    execute 'highlight MinesweeperWin ctermfg=Green guifg=#00FF00 gui=bold'
    execute 'highlight MinesweeperLose ctermfg=Red guifg=#FF0000 gui=bold'
  enddef

  # Generate display lines
  def GenerateLines(): list<string>
    var lines: list<string> = []
    
    # Calculate content width
    var fixedCellWidth = this.GetFixedCellWidth()
    var contentWidth = this.game.board.width * fixedCellWidth
    
    # Generate each section
    var headerLines = this.GenerateHeader(contentWidth)
    for line in headerLines
      add(lines, line)
    endfor
    
    add(lines, '')
    
    var boardLines = this.GenerateBoard(contentWidth)
    for line in boardLines
      add(lines, line)
    endfor
    
    var footerLines = this.GenerateFooter()
    for line in footerLines
      add(lines, line)
    endfor
    
    return lines
  enddef

  # Render the game
  def Render()
    if this.winid < 0
      return
    endif

    var lines = this.GenerateLines()
    popup_settext(this.winid, lines)
  enddef

  # Close the window
  def Close()
    if this.timer_id > 0
      timer_stop(this.timer_id)
      this.timer_id = -1
    endif
    if this.winid > 0
      popup_close(this.winid)
    endif
    this.winid = -1
    this.bufnr = -1
  enddef
endclass
