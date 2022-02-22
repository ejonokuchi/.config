# zsh

A simple, fast configuration for zsh.

If you don't have a lot of time or interest, the easiest way to get set up is a configuration framework like [Prezto](https://github.com/sorin-ionescu/prezto) or [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).


## Directory

```
~/config/zsh
├── functions                   # User functions
│   └── ...
├── .aliases                    # User aliases
├── .zlogin
├── .zlogout
├── .zprofile
├── .zshenv                     # Global environment variables
├── .zshrc                      # zsh configuration file
└── README.md
```


## Installation

First create a backup copy of your current configuration. The usual location is `~/.zshrc`.

Create symlinks for the functions and dotfiles, from `~/config`:

```bash
[[ -e "${HOME}/.config/zsh" ]] || mkdir -p "${HOME}/.config/zsh"

# Link functions to: ~/.config/zsh/functions
ln -s "${HOME}/config/zsh/functions" "${HOME}/.config/zsh/functions"

# Link dotfiles to: ~/.config/zsh
ln -s "${HOME}/config/zsh/.aliases" "${HOME}/.config/zsh/.aliases"
ln -s "${HOME}/config/zsh/.zlogin" "${HOME}/.config/zsh/.zlogin"
ln -s "${HOME}/config/zsh/.zlogout" "${HOME}/.config/zsh/.zlogout"
ln -s "${HOME}/config/zsh/.zprofile" "${HOME}/.config/zsh/.zprofile"
ln -s "${HOME}/config/zsh/.zshrc" "${HOME}/.config/zsh/.zshrc"

# Link env file to: ~/
ln -s "${HOME}/config/zsh/.zshenv" "${HOME}/.zshenv"
```

Be sure to review the implementation details below, and edit as needed.


## Features

- extended history with substring search
- intuitive, menu-based completion
- custom prompt with git and venv
- lazy-loaded shell utilities: virtualenv, nvm, rvm
- zmv


## Dependencies

Several external tools are referenced in the configuration.

System packages, via `brew install`:
- [tmux](https://github.com/tmux/tmux/wiki): terminal multiplexer
- [tree](https://linux.die.net/man/1/tree): list files in a tree-like format (see above)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search): search zsh history for partial commands

Others, via the links provided:
- [Python 3.9](https://www.python.org/downloads/release/python-3910/)
- [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/): Python environment manager
- [gcloud](https://cloud.google.com/sdk/gcloud): the CLI tool for the Google Cloud SDK
- [nvm](https://github.com/nvm-sh/nvm): Node version manager
- [rvm](https://rvm.io/): Ruby version manager


## Additional notes

### XDG config directory

Uses `.zshenv` to set the `XDG_CONFIG_HOME` to `~/.config`.

This keeps the home directory uncluttered. Keep a mental note, since many applications often default to using the home directory.


### Startup files

For an interactive shell, files are sourced in the following order:

`.zshenv` → `.zprofile` → `.zshrc` → `.zlogin` → ... *the session* ... → exit → `.zlogout`

I've included all of them for completeness, but only the `.zshenv` and `.zshrc` are actually used.


### Performance

I used to use Oh My Zsh, but the startup time was frustratingly slow. It took about ~1.5 s to open a new terminal pane.

This was my initial motivation for doing a deep-dive on zsh. Eventually, I realized that zsh had most of the features I wanted built-in, and I ditched the framework.

With this configuration, new shells load in <0.15 s:

<img width="921" alt="tsh-demo" src="https://user-images.githubusercontent.com/19394509/155053554-4e53330b-d167-4702-b7af-8d213c8cb1b4.png">

Check yours with this command:

```bash
for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done
```

If you want to speed up your configuration as is, there are countless blog posts on this topic. The usual low-hanging fruit is to lazy-load shell utilities like nvm (see [.zshrc](./.zshrc#L188-L193) and [functions/nvm](./functions/nvm)).

Add these lines to the beginning and end of your `.zshrc` to run the built-in profiler on startup:

```bash
zmodload zsh/zprof

# ...

zprof
```


## See also

- [A User's Guide to the Z-Shell](https://zsh.sourceforge.io/Guide/zshguide.html): comprehensive guide to zsh
- [Moving to zsh](https://scriptingosx.com/2019/06/moving-to-zsh/): useful walkthrough blog post
- [What should/shouldn't go in .zshenv, .zshrc, .zlogin, .zprofile, .zlogout?](https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout): ELI5 of zsh startup files
