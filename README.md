# Minesweeper game in vim9script

A fully-featured Minesweeper game written in Vim9script, showcasing modern Vim9 features including classes, interfaces, enums, and type aliases.

## Requirements

- Vim 9.0 or later with Vim9script support
- **NOT compatible with Neovim** (requires Vim9-specific features)

## Installation

### Using Git
If you have git installed, run the following command in your terminal:

**Unix/Linux/macOS:**

```bash
git clone https://github.com/yegappan/minesweeper.git ~/.vim/pack/downloads/opt/minesweeper
```
**Windows (cmd.exe):**

```cmd
git clone https://github.com/yegappan/minesweeper.git %USERPROFILE%\vimfiles\pack\downloads\opt\minesweeper
```

### Using a ZIP file
If you prefer not to use Git:

**Unix/Linux/macOS:**

Create the destination directory:

```bash
mkdir -p ~/.vim/pack/downloads/opt/
```

Download the plugin ZIP file from GitHub and extract its contents into the directory created above.

*Note:* GitHub usually names the extracted folder minesweeper-main. Rename it to minesweeper so the final path looks like this:

```plaintext
~/.vim/pack/downloads/opt/minesweeper/
├── plugin/
├── autoload/
└── doc/
```

**Windows (cmd.exe):**

Create the destination directory:

```cmd
if not exist "%USERPROFILE%\vimfiles\pack\downloads\opt" mkdir "%USERPROFILE%\vimfiles\pack\downloads\opt"
```

Download the plugin ZIP file from GitHub and extract its contents into that directory.

*Note:* Rename the extracted folder (usually minesweeper-main) to minesweeper so the path matches:

```plaintext
%USERPROFILE%\vimfiles\pack\downloads\opt\minesweeper\
├── plugin/
├── autoload/
└── doc/
```

### Finalizing Setup
Since this plugin is installed in the opt (optional) directory, it will not load automatically. Add the following line to your .vimrc (Unix) or _vimrc (Windows):

```viml
packadd minesweeper
```

After adding the line, restart Vim and run the following command to enable the help documentation:

```viml
:helptags ALL
```

### Plugin Manager Installation

If using a plugin manager like vim-plug, add to your .vimrc or init.vim:

   ```viml
   Plug 'path/to/minesweeper'
   ```

Then run `:PlugInstall` and `:helptags ALL`

For other plugin managers (Vundle, Pathogen, etc.), follow their standard
installation procedures for local plugins.

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
