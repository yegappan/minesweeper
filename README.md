# Minesweeper Game in Vim9script

A fully-featured Minesweeper game with multiple difficulty levels. Reveal cells and flag mines to win. Written in Vim9script to showcase classes, interfaces, enums, and type aliases.

## Features

- **Multiple Difficulty Levels**: Easy (8x8, 10 mines), Medium (16x16, 40 mines), Hard (30x16, 99 mines)
- **Custom Difficulty**: Configure custom board size and mine count
- **Cell Flagging**: Mark suspected mine locations
- **Number Reveal**: Shows mine count for adjacent cells
- **Win/Lose Detection**: Automatic game end detection
- **Popup Window UI**: Clean, centered display
- **Modern Vim9script**: Demonstrates OOP and type safety

## Requirements

- Vim 9.0 or later with Vim9script support
- **NOT compatible with Neovim** (requires Vim9-specific features)

## Installation

### Using Git

**Unix/Linux/macOS:**
```bash
git clone https://github.com/yegappan/minesweeper.git ~/.vim/pack/downloads/opt/minesweeper
```

**Windows (cmd.exe):**
```cmd
git clone https://github.com/yegappan/minesweeper.git %USERPROFILE%\vimfiles\pack\downloads\opt\minesweeper
```

### Using a ZIP file

**Unix/Linux/macOS:**
```bash
mkdir -p ~/.vim/pack/downloads/opt/
```
Download the ZIP file from GitHub and extract it into the directory above. Rename the extracted folder (usually minesweeper-main) to `minesweeper` so the final path matches:

```plaintext
~/.vim/pack/downloads/opt/minesweeper/
├── plugin/
├── autoload/
└── doc/
```

**Windows (cmd.exe):**
```cmd
if not exist "%USERPROFILE%\vimfiles\pack\downloads\opt" mkdir "%USERPROFILE%\vimfiles\pack\downloads\opt"
```
Download the ZIP file from GitHub and extract it into the directory above. Rename the extracted folder (usually minesweeper-main) to `minesweeper` so the final path matches:

```plaintext
%USERPROFILE%\vimfiles\pack\downloads\opt\minesweeper\
├── plugin/
├── autoload/
└── doc/
```

### Finalizing Setup

Since the plugin is in the `opt` directory, add this to your `.vimrc` (Unix) or `_vimrc` (Windows):
```viml
packadd minesweeper
```

Then restart Vim and run:
```viml
:helptags ALL
```

### Plugin Manager Installation

If using vim-plug, add to your config:
```viml
Plug 'path/to/minesweeper'
```
Then run `:PlugInstall` and `:helptags ALL`.

For other plugin managers, follow their standard procedure for local plugins.

## Usage

### Starting the Game

Default settings (10x10, 10 mines):
```vim
:Minesweeper
```

Predefined difficulty levels:
```vim
:MinesweeperEasy      " 8x8 board, 10 mines
:MinesweeperMedium    " 16x16 board, 40 mines
:MinesweeperHard      " 30x16 board, 99 mines
```

### Custom Configuration

Set custom dimensions in your vimrc:
```vim
let g:minesweeper_width = 15
let g:minesweeper_height = 15
let g:minesweeper_mines = 25
```

Then run `:Minesweeper`.

### Controls

| Key | Action |
|-----|--------|
| `h` / `←` | Move cursor left |
| `j` / `↓` | Move cursor down |
| `k` / `↑` | Move cursor up |
| `l` / `→` | Move cursor right |
| `Space` / `Enter` | Reveal cell |
| `f` | Toggle flag on cell |
| `r` | Restart game |
| `q` / `Esc` | Quit game |

### Game Rules

- Numbers show how many mines are in adjacent cells
- Flag cells you believe contain mines
- Win by flagging all mines
- Lose by revealing a mine
- Unrevealed cells can be flagged or revealed

## Vim9 Language Features Demonstrated

- **Classes**: Game state management and board logic with encapsulation
- **Interfaces**: Type-safe contracts for game components
- **Enums**: Type-safe cell states (hidden, revealed, flagged)
- **Type Aliases**: Semantic typing for coordinates and board state
- **Type Checking**: Full type annotations on parameters and returns
- **Modular Architecture**: Separation of concerns across files
- **Popup Windows**: Modern Vim UI with floating windows

## License

This plugin is licensed under the MIT License. See the LICENSE file in the repository for details.

