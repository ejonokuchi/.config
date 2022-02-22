#!/usr/bin/env zsh
#
# Global environment variables.
#

# Warning: this file is sourced by almost every zsh, so it's good practice to keep it simple.

# Define a config directory, to keep the home directory uncluttered.
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${XDG_CONFIG_HOME}/local/share"
export XDG_CACHE_HOME="${XDG_CONFIG_HOME}/cache"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
