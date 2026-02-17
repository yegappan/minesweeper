vim9script

# Game constants and symbols

# Symbol sets for GUI and terminal modes
export var SYMBOLS_GUI = {
  mine: '💣',
  flag: '🚩',
  empty_cell: '📦',
  empty_space: '·',
  title_decor: '⭐',
  cursor_left: '👉',
  cursor_right: '👈',
  win: '🎉',
  lose: '💥'
}

export var SYMBOLS_TERMINAL = {
  mine: '✕',
  flag: '⚑',
  empty_cell: '▢',
  empty_space: '·',
  title_decor: '✕',
  cursor_left: '▶',
  cursor_right: '◀',
  win: '✓',
  lose: '✗'
}

# UI dimensions
export var CELL_WIDTH_TERMINAL: number = 3
export var CELL_WIDTH_GUI: number = 4

# Border characters
export var BORDER_CHARS = {
  top_left: '╔',
  top_right: '╗',
  bottom_left: '╚',
  bottom_right: '╝',
  horizontal: '═',
  vertical: '║',
  vertical_right: '╣',
  vertical_left: '╠'
}

# Instructions
export var INSTRUCTION_MOVE: string = '[hjkl] Move'
export var INSTRUCTION_REVEAL: string = '[Space] Reveal'
export var INSTRUCTION_FLAG: string = '[f] Flag'
export var INSTRUCTION_RESTART: string = '[r] Restart'
export var INSTRUCTION_QUIT: string = '[q] Quit'

export var FULL_INSTRUCTIONS_1: string = ' ' .. INSTRUCTION_MOVE .. '  ' .. INSTRUCTION_REVEAL .. ' '
export var FULL_INSTRUCTIONS_2: string = ' ' .. INSTRUCTION_FLAG .. '  ' .. INSTRUCTION_RESTART .. '  ' .. INSTRUCTION_QUIT .. ' '
