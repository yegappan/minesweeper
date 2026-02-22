# Minesweeper for Vim9

A fully-featured Minesweeper game written in Vim9script, showcasing modern Vim9 features including classes, interfaces, enums, and type aliases.

## Requirements

- Vim 9.0 or later with Vim9script support
- **NOT compatible with Neovim** (requires Vim9-specific features)

## Installation

You can install this plugin directly from github using the following steps:

   **Unix/Linux/macOS:**
   ```bash
   git clone https://github.com/yegappan/minesweeper.git $HOME/.vim/pack/downloads/opt/minesweeper
   vim -u NONE -c "helptags $HOME/.vim/pack/downloads/opt/minesweeper/doc" -c q
   ```

   **Windows:**
   ```cmd
   git clone https://github.com/yegappan/minesweeper.git %USERPROFILE%\vimfiles\pack\downloads\opt\minesweeper
   vim -u NONE -c "helptags $HOME/vimfiles/pack/downloads/opt/minesweeper/doc" -c q
   ```

After installing the plugin using the above steps, add the following line to
the $HOME/.vimrc (Unix/Linux/macOS) or the $HOME/_vimrc (Windows) file:

```viml
packadd minesweeper
```

You can also install and manage this plugin using any one of the Vim plugin managers (dein.vim, pathogen, vam, vim-plug, volt, Vundle, etc.).

## Usage

### Starting the Game

```vim
" Start with default settings (10x10, 10 mines)
:Minesweeper

" Start with predefined difficulty levels
:MinesweeperEasy      " 8x8, 10 mines
:MinesweeperMedium    " 16x16, 40 mines
:MinesweeperHard      " 30x16, 99 mines
```

### Custom Configuration

You can set custom board dimensions and mine count in your vimrc:

```vim
let g:minesweeper_width = 15
let g:minesweeper_height = 15
let g:minesweeper_mines = 25
```

Then run `:Minesweeper` to use these settings.

## Controls

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

## Help

The plugin ships with a Vim help file:

```
:help minesweeper
```

## Game Rules

1. The board consists of a grid of cells
2. Some cells contain hidden mines
3. Click (reveal) a cell to uncover it
4. Numbers indicate how many mines are adjacent to that cell
5. Flag cells you think contain mines
6. Win by flagging all mines
7. Lose by revealing a mine

## Development

The codebase demonstrates:

- Object-oriented design with classes and encapsulation
- Type safety with Vim9's type system
- Modular architecture for maintainability
- Clean separation of concerns
- Modern Vim9 syntax and features
- Popup window API for floating UI
- Filter functions for event handling
- GUI/terminal symbol support with consistent layout

## License

MIT License - Feel free to use and modify

## Contributing

Contributions are welcome! Please ensure:

1. Code uses Vim9script syntax
2. All functions have type annotations
3. Classes and modules follow the existing structure
4. Changes maintain Vim 9.0+ compatibility

## Troubleshooting

### Check Vim Version

```vim
:version
```

Ensure you have Vim 9.0 or later.

## Credits

Created as a demonstration of modern Vim9script capabilities, including classes, enums, type aliases, and modular plugin architecture.
