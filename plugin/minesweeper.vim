vim9script
# Minesweeper Game Plugin for Vim9
# Logic puzzle - reveal safe cells by deducing mine locations
# Requires: Vim 9.0+

if exists('g:loaded_minesweeper')
  finish
endif
g:loaded_minesweeper = 1

import autoload '../autoload/minesweeper.vim' as Minesweeper

# Default configuration variables
if !exists('g:minesweeper_width')
  g:minesweeper_width = 10
endif
if !exists('g:minesweeper_height')
  g:minesweeper_height = 10
endif
if !exists('g:minesweeper_mines')
  g:minesweeper_mines = 10
endif

# Commands to start the game at different difficulty levels
command! Minesweeper call Minesweeper.Start()
command! MinesweeperEasy call Minesweeper.StartDifficulty('easy')
command! MinesweeperMedium call Minesweeper.StartDifficulty('medium')
command! MinesweeperHard call Minesweeper.StartDifficulty('hard')
