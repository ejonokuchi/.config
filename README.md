# ejonokuchi/config

My configurations for various developer tools, e.g. zsh, tmux, and vscode.

Caveat emptor.


## Directory

```
~/config
├── git
│   └── config
├── iterm
│   └── com.googlecode.iterm2.plist
├── scripts
│   └── ...
├── tmux
│   └── .tmux.conf
├── vscode
│   ├── keybindings.json
│   └── settings.json
├── warp
│   └── themes
│       └── emj.yaml
├── zsh
│   └── ...
└── install.sh
```


## Installation

For Mac only.

Note: Expected use is on a new machine without any existing dependencies/configurations. It's strongly recommended that you install components individually, as needed.

Clone the repo, and run the installation script:

```bash
git clone git@github.com:ejonokuchi/config.git
cd config
./install.sh
```

The script will install system packages, and copy or symlink the configuration files to the appropriate locations. Existing files will be backed up.

The following additional tools are referenced in the `.zshrc` file and are recommended:
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install), to `~/third-party/google-cloud-sdk`
- [nvm](https://github.com/nvm-sh/nvm) (Node version manager), to `~/.nvm`
- [rvm](https://rvm.io/rvm/install) (Ruby version manager), to `~/.rvm`

These are not included by default as the latest versions may have changed since this script was last updated.


## Tools

These are the tools I would add to a new computer, for personal reference.

Note: zsh is included from macOS Catalina and onward (2019+).

Applications:
- [VS Code](https://code.visualstudio.com/): IDE and Markdown notes
- [Warp](https://www.warp.dev/): Rust-based terminal for Mac[^1]
- [iTerm](https://iterm2.com/): terminal emulator for Mac
- [Spotify](https://www.spotify.com/us/download/other/)

System packages, via `brew install`:
- [ffmpeg](https://www.ffmpeg.org/): record and process audio and video files
- [htop](https://htop.dev/): interactive process viewer
- [jq](https://stedolan.github.io/jq/): JSON processor
- [ngrok](https://ngrok.com/): expose local ports to public URLs
- [pyenv](https://github.com/pyenv/pyenv): simple Python version manager
- [tldr](https://tldr.sh/): simplified man pages
- [tmux](https://github.com/tmux/tmux/wiki): terminal multiplexer
- [tree](https://linux.die.net/man/1/tree): list files in a tree-like format (see above)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search): search zsh history for partial commands

Menu bar add-ons:
- [Flux](https://justgetflux.com/): adjusts display to reduce blue light at night
- [KeepingYouAwake](https://keepingyouawake.app/): keeps computer display on when activated
- [Rectangle](https://rectangleapp.com/): snap windows to full-screen, half-screen, etc.
- [MeetingBar](https://apps.apple.com/us/app/meetingbar/id1532419400): see calendar and join meetings from the menu bar


## See also

Designing a terminal theme:
- Choose a sensible ANSI color palette: [terminal.sexy](https://terminal.sexy/)
- Gallery of all xterm colors: [256-colors](https://robotmoon.com/256-colors/)



<!-- footnotes -->

[^1]: Warp is currently in beta. It's very promising, but I still sometimes prefer iTerm.
