# .config/vscode

VS Code settings.


## Installation

To install VS Code, see [code.visualstudio.com](https://code.visualstudio.com/download).

To link the settings and keybindings from `~/.config`:

```bash
ln -s "${HOME}/.config/vscode"/*.json "${HOME}/Library/Application Support/Code/User/"
```

For non-Mac users, [see the documentation](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations) for alternate paths to the User settings file.

Note: I use `black` as the default Python formatter, installed in a venv in `~/.venvs`.


## Extensions

List of enabled extensions:
- autoDocstring
- C/C++
- Markdown All in One
- Markdown PDF
- Material Icon Theme
- multi-command
- Prettier
- Python (includes Pylance, Jupyter, etc.)
- Sass
