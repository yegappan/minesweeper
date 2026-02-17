vim9script

# Minesweeper game plugin for Vim9
# Author: GitHub Copilot
# Version: 1.0.0
# Requires: Vim 9.0+

if exists('g:loaded_minesweeper')
  finish
endif
g:loaded_minesweeper = 1

import autoload '../autoload/minesweeper.vim'

# Default configuration
if !exists('g:minesweeper_width')
  g:minesweeper_width = 10
endif

if !exists('g:minesweeper_height')
  g:minesweeper_height = 10
endif

if !exists('g:minesweeper_mines')
  g:minesweeper_mines = 10
endif

# Command to start the game
command! Minesweeper call minesweeper.Start()
command! MinesweeperEasy call minesweeper.StartDifficulty('easy')
command! MinesweeperMedium call minesweeper.StartDifficulty('medium')
command! MinesweeperHard call minesweeper.StartDifficulty('hard')
